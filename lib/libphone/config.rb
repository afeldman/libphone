# frozen_string_literal: true

require "shale"
require "tomlib"

module LibPhone
  class PhoneConfig
    class Config < Shale::Mapper
      attribute :host, Shale::Type::String, default: -> { "localhost" }
      attribute :verify, Shale::Type::Boolean, default: -> { true }
    end

    attr_reader :config, :instance

    @instance_mutex = Mutex.new

    private_class_method :new

    def initialize(host = nil, verify = nil)
      @config = Config.new

      @config.host = host unless host.nil?
      @config.verify = verify unless verify.nil?
    end

    def self.from_file(config_file)
      config = PhoneConfig.instance

      if !config_file.nil? && File.exist?(config_file)

        info = nil
        content = File.read(config_file)

        case File.extname(config_file).downcase
        when ".tml", ".toml"
          info = Config.from_toml(content)
        when ".yml", ".yaml"
          info = Config.from_yaml(content)
        when ".json", ".js"
          info = Config.from_json(content)
        when ".xml"
          info = Config.from_xml(content)
        else
          p "wrong datatype"
        end

        config.config = info
      end

      config
    end

    def self.instance(host = nil, verify = nil)
      return @instance if @instance

      @instance_mutex.synchronize do
        @instance ||= new(host, verify)
      end

      @instance
    end

    def to_toml
      Shale.toml_adapter = Tomlib
      @config.to_toml
    end

    def to_cjson
      @config.to_json
    end

    def to_yaml
      @config.to_yaml
    end
  end
end
