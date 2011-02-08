module Bosh
end

require 'logger'

require 'redis'
require "yajl"
require 'uuidtools'
require 'ostruct'

require "agent/ext"
require "agent/version"
require "agent/config"
require "agent/util"

# TODO the message handlers will be loaded dynamically
require "agent/message/disk"
require "agent/message/configure"
require "agent/message/state"
require "agent/message/drain"
require "agent/message/apply"
require "agent/message/compile_package"

require "agent/handler"

module Bosh::Agent

  class << self
    def run(options = {})
      Runner.new(options).start
    end
  end

  class Runner < Struct.new(:config, :pubsub_redis, :redis)

    def initialize(options)
      self.config = Bosh::Agent::Config.setup(options)
    end

    def start
      $stdout.sync = true
      @logger = Bosh::Agent::Config.logger
      @logger.info("Configuring agent #{Bosh::Agent::VERSION}")
      if Config.configure
        Bosh::Agent::Message::Configure.process(nil)
      end
      @logger.info("Starting agent")
      Bosh::Agent::Handler.start
    end
  end

end

if __FILE__ == $0
  options = {
    "configure" => true,
    "logging" => { "level" => "DEBUG" },
    "redis" => { "host" => "localhost" },
    "agent_id" => "not_configured",
    "base_dir" => "/var/vmc"
  }
  Bosh::Agent.run(options)
end
