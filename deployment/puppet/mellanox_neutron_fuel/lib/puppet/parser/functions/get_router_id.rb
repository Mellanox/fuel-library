module Puppet::Parser::Functions
  newfunction(:get_router_id, :type => :rvalue) do |args|
    `. /root/openrc ; neutron router-list |grep router | awk {'print $2'}`
  end
end

