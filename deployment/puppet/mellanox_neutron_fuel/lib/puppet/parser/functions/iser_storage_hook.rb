module Puppet::Parser::Functions
  newfunction(:iser_storage_hook, :type => :rvalue) do |args|

    fuel_settings = args[0]
    iser_enabled = fuel_settings['storage']['ISER']
    Puppet.debug("ISER enabled: #{iser_enabled}")

    if iser_enabled:

      # Get the physical interface bridge
      source_br = ''
      network_scheme = fuel_settings['network_scheme']
      transformations = network_scheme['transformations']
      transformations.delete_if do |trans|
        if (trans['action'] == 'add-patch' and trans['bridges'].include?('br-storage')):
          trans['bridges'].each do |br|
            source_br = br unless br == 'br-storage'
          end
          true
        end
      end

      # Remove problematic transformations
      source_interface = source_br.gsub('br-','')
      transformations.delete_if do |trans|
        next if trans['name'].nil?
        if (trans['name'].include?(source_interface) or trans['name'].include?('br-storage')):
          true
        end
      end

      # Set storage role and endpoint
      network_scheme['roles']['storage']=source_interface
      network_scheme['endpoints']["#{source_interface}"]=network_scheme['endpoints'].delete('br-storage')

    end

    return fuel_settings
  end
end

