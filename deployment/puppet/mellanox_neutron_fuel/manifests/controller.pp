class mellanox_neutron_fuel::controller{

    package{'mellanox_testvm': ensure => installed}

    $services = ['openstack-nova-api',
                 'openstack-nova-cert',
                 'openstack-nova-conductor',
                 'openstack-nova-consoleauth',
                 'openstack-nova-novncproxy',
                 'openstack-nova-scheduler']

    File_line {path  => '/etc/nova/nova.conf', notify => [Service[$services]]}

    $file_lines = {
      'nova_conf_security' => {
        line  => 'security_group_api=nova',
        match => "^security_group_api\s*="
        },
    }

    create_resources( File_line, $file_lines )

    if $install_iser == true{
      file_line {'nova_conf_volume_drivers' :
        path  => '/etc/nova/nova.conf',
        line  => 'libvirt_volume_drivers = iser=nova.virt.libvirt.volume.LibvirtISERVolumeDriver',
        match => "^#*libvirt_volume_drivers\s*=",
        notify => [Service[$services]]
      }
    }

}

