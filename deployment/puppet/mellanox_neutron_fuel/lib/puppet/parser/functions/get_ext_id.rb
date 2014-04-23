module Puppet::Parser::Functions
  newfunction(:get_ext_id, :type => :rvalue) do |args|
    `. /root/openrc ; neutron net-list |grep ext|awk {'print $2'}`
  end
end

