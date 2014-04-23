class mellanox_neutron_fuel::clean_neutron_server{

    # Stop neutron-server service
    service{'neutron-server': ensure => stopped}

}
