Facter.add(:neutron_port) do
  setcode do
    `ibdev2netdev |grep Up | head -1 | awk {'print $5'}`.gsub("/n","")
  end
end
