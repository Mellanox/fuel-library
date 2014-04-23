#Use this format of configuration assignment in /etc/puppet/manifests/site.pp in order to
#configure mellanox neutron plugin.
#configuration stages are mentioned for each role.

# Configure parameters (must be configured)

$iser_ip_address=<CINDER_IP>
$controller_inband_IP=<CONTROLLER_IP>
$mlnx_neutron_root_password=<MYSQL_DEFAULT_PASSWORD>
$min_vlan=<MIN_VLAN>
$max_vlan=<MAX_VLAN>

# Associate

node 'controller_and_neutron_node'{
  # Step 1: Enable in order to run controller cleanup
  include mellanox_neutron_fuel::clean_controller
  include mellanox_neutron_fuel::clean_neutron_server

  # Step 2: Enable in order to run controller configuration
  #include mellanox_neutron_fuel::controller
  #include mellanox_neutron_fuel::network_node

  # Step 3: Enable in order to run neutron_server configuration
  #include mellanox_neutron_fuel::neutron_server
}

node 'compute_node'{
  # Step 4: Enable in order to run compute node configuration
  #include mellanox_neutron_fuel::compute_node
}

node 'cinder_node'{
  # Step 4: Enable in order to run cinder node configuration
  #include mellanox_neutron_fuel::cinder_node
}
