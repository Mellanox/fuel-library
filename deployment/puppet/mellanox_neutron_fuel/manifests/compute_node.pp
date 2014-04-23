class mellanox_neutron_fuel::compute_node{

    # Install compute node packages
    package{'eswitchd': ensure=>installed}
    package{'mlnxvif': ensure=>installed}
    package{'openstack-neutron-mellanox': ensure=>installed}

    # Set common parameters and order to File lines
    File_line{
              path   => '/etc/nova/nova.conf',
              require => [Package['eswitchd'],Package['mlnxvif'],Package['openstack-neutron-mellanox']],
              before => [Service['openstack-nova-compute'],Service['eswitchd'],Service['neutron-mlnx-agent']]
             }

    # Set order to File
    File{before => [Service['openstack-nova-compute'],Service['eswitchd'],Service['neutron-mlnx-agent']]}

    # Change /etc/eswitchd/eswitchd.conf
    file { "eswitchd.conf":
      path    => "/etc/eswitchd/eswitchd.conf",
      content => template('mellanox_neutron_fuel/mlnx_eswitchd_template.erb'),
      require => Package['eswitchd'],
    }

    # Ensure lines in /etc/nova/nova.conf
    $file_lines = {
      'nova_compute_driver'     => {
                        line    =>'compute_driver=nova.virt.libvirt.driver.LibvirtDriver',
                        match   => "^compute_driver\s*="},
      'nova_libvirt_vif_driver' => {
                        line    =>'libvirt_vif_driver=mlnxvif.vif.MlxEthVIFDriver',
                        match   => "^libvirt_vif_driver\s*="},
      'nova_security_group_api' => {
                        line    =>'security_group_api=nova',
                        match   => "^security_group_api\s*="},
      'nova_connection_type'    => {
                        line    =>'connection_type=libvirt',
                        match   => "^connection_type\s*="},
    }

    create_resources( file_line, $file_lines )

    # Change mlnx_conf.ini
    file { 'mlnx_conf.ini':
      path    => "/etc/neutron/plugins/mlnx/mlnx_conf.ini",
      content => template('mellanox_neutron_fuel/mlnx_conf_template.erb'),
      require => Package['openstack-neutron-mellanox']
    }

    # Start services
    service{'neutron-openvswitch-agent': ensure => stopped, enable => false, before => Service['openstack-nova-compute']}
    service{'eswitchd': ensure => running, enable => true, notify => Service['neutron-mlnx-agent']}
    service{'neutron-mlnx-agent': ensure => running, enable => true, notify => Service['openstack-nova-compute']}
}

