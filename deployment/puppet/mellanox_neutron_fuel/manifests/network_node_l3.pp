node default{
  $router_id = get_router_id()
  $ext_id = get_ext_id()

  File_line {path => '/etc/neutron/l3_agent.ini',notify=>Service['neutron-l3-agent']}

  $file_lines= {
    'l3_agent_driver.ini'=>
      {line    =>'interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver',
      match   => "^interface_driver\s*="},
    'l3_agent_router.ini'=>
      {line    =>"router_id = $router_id",
      match   => "^#*\s*router_id\s*="},
    'l3_agent_ext.ini'=>
      {line    =>"gateway_external_network_id = $ext_id",
      match   => "^#*\s*gateway_external_network_id\s*="},
  }

  create_resources(File_line, $file_lines)

  service{'neutron-l3-agent': ensure => running, enable=>true}
}
