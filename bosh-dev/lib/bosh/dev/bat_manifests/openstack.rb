module Bosh
  module Dev
    module BatManifests
      class Openstack
        attr_accessor :vip
        attr_accessor :net_id
        attr_accessor :net_cidr
        attr_accessor :net_reserved_string
        attr_accessor :net_static
        attr_accessor :net_gateway
        attr_accessor :stemcell_version_override

        def initialize(env)
          @vip = env['BOSH_OPENSTACK_VIP_BAT_IP']
          @net_id = env['BOSH_OPENSTACK_NET_ID']
          @net_cidr = env['BOSH_OPENSTACK_NETWORK_CIDR']
          @net_reserved_string = env['BOSH_OPENSTACK_NETWORK_RESERVED']
          @net_static = env['BOSH_OPENSTACK_NETWORK_STATIC']
          @net_gateway = env['BOSH_OPENSTACK_NETWORK_GATEWAY']
        end

        def net_reserved
          net_reserved_string.split(/[|,]/).map(&:strip)
        end

        def stemcell_version
          stemcell_version_override || 'latest'
        end

        def generate(template_path, output_path, net_type, director_uuid)
          bat_manifest = ERB.new(File.read(template_path)).result(binding)

          File.write(output_path, bat_manifest)
        end
      end
    end
  end
end
