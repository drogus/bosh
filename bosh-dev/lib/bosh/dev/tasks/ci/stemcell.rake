namespace :ci do
  namespace :stemcell do
    desc 'Build micro bosh stemcell from CI pipeline'
    task :micro, [:infrastructure] do |_, args|
      require 'bosh/dev/stemcell_builder'
      require 'bosh/dev/stemcell_publisher'

      stemcell_builder = Bosh::Dev::StemcellBuilder.new('micro', args[:infrastructure])
      publisher = Bosh::Dev::StemcellPublisher.new
      publisher.publish(stemcell_builder.build)
    end

    desc 'Build stemcell from CI pipeline'
    task :basic, [:infrastructure] do |_, args|
      require 'bosh/dev/stemcell_builder'
      require 'bosh/dev/stemcell_publisher'

      stemcell_builder = Bosh::Dev::StemcellBuilder.new('basic', args[:infrastructure])
      publisher = Bosh::Dev::StemcellPublisher.new
      publisher.publish(stemcell_builder.build)
    end

    desc 'run some chef'
    task :chef_in_chroot do
      require 'bosh/dev/stemcell_builder'
      require 'bosh/dev/stemcell_publisher'

      stemcell_builder = Bosh::Dev::StemcellBuilder.new('basic', 'aws')
      stemcell_builder.build
      #sh <<-BASH
      #  mkdir tmp/jail
      #  #chroot -d tmp/jail -c chef-solo blah.rb
      #  chroot -d tmp/jail -c 'touch /foo'
      #BASH
      #
      #File.exist?('tmp/jail/foo') or raise 'foo does not exist'
    end
  end
end
