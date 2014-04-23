class mellanox_neutron_fuel::network_node{

    # Install compute node packages
    package{'openstack-neutron-linuxbridge': ensure=>installed}
    package{'openstack-neutron-openvswitch': ensure=>installed} #For dhcp

    # Change /etc/eswitchd/eswitchd.conf
    file { "linuxbridge_conf.ini":
      path    => "/etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini",
      content => template('mellanox_neutron_fuel/mlnx_linuxbridge_template.erb'),
      require => Package['openstack-neutron-linuxbridge'],
      notify  => Service['neutron-linuxbridge-agent']
    }

    # Ensure lines in /etc/nova/nova.conf
    file_line {
      'dhcp_agent.ini':
        path => '/etc/neutron/dhcp_agent.ini',
        line    =>'interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver',
        match   => "^interface_driver\s*=",
        require => File['linuxbridge_conf.ini'],
        notify  => [Service['neutron-dhcp-agent'],Service['neutron-linuxbridge-agent']]
    }

    # Start services
    service{
      'neutron-openvswitch-agent':
        ensure  => stopped,
        enable  => false,
        before  => [Service['neutron-linuxbridge-agent'], Service['neutron-linuxbridge-agent']],
        require => File_line['dhcp_agent.ini']
    }

    service{'neutron-linuxbridge-agent': ensure => running, enable => true, subscribe => Service['neutron-dhcp-agent']}
}

