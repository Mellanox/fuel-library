class mellanox_neutron_fuel::cinder_node{

    # Set common parameters and order to File lines
    File_line{path => '/etc/cinder/cinder.conf', notify => Service['openstack-cinder-volume']}

    $file_lines = {
      'cinder_iser_ip_address'     => {
                        line    => "iser_ip_address = ${iser_ip_address}",
                        match   => "^#*iser_ip_address\s*="},
      'cinder_volume_driver' => {
                        line    =>'volume_driver = cinder.volume.drivers.lvm.LVMISERDriver',
                        match   => "^#*volume_driver\s*="}
    }

    # Ensure lines in /etc/cinder/cinder.conf
    create_resources( file_line, $file_lines )

}

