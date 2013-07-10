module Bosh
  module Dev
    module BatManifests
      class Vsphere
        attr_accessor :ip
        attr_accessor :net_id
        attr_accessor :net_cidr
        attr_accessor :net_reserved_admin
        attr_accessor :net_reserved_string
        attr_accessor :net_static_bat
        attr_accessor :net_static_bosh
        attr_accessor :gateway
        attr_accessor :stemcell_version_override
        attr_accessor :microbosh_ip

        def initialize(env)
          @ip = env['BOSH_BAT_IP']
          @net_id = env['BOSH_VSPHERE_NET_ID']
          @net_cidr = env['BOSH_VSPHERE_NETWORK_CIDR']
          @net_reserved_admin = env['BOSH_VSPHERE_NETWORK_RESERVED_ADMIN']
          @net_reserved_string = env['BOSH_VSPHERE_NETWORK_RESERVED']
          @net_static_bat = env['BOSH_VSPHERE_NETWORK_STATIC_BAT']
          @net_static_bosh = env['BOSH_VSPHERE_NETWORK_STATIC_BOSH']
          @gateway = env['BOSH_VSPHERE_GATEWAY']
          @microbosh_ip = env['BOSH_MICROBOSH_IP']
        end

        def net_reserved
          net_reserved_string.split(/[|,]/).map(&:strip)
        end

        def stemcell_version
          stemcell_version_override || 'latest'
        end

        def generate(template_path, output_path, director_uuid)
          bat_manifest = ERB.new(File.read(template_path)).result(binding)

          File.write(output_path, bat_manifest)
        end
      end
    end
  end
end
