# frozen_string_literal: true

require "httparty"
require "shale"

require_relative "config"

# send data to the libphone api server and get the responce
module LibPhone
  class Phone
    class Contry < Shale::Mapper
      attribute :code, Shale::Type::String, default: -> { "" }
      attribute :name, Shale::Type::String, default: -> { "" }
      attribute :prefix, Shale::Type::String, default: -> { "" }
    end

    class Format < Shale::Mapper
      attribute :international, Shale::Type::String, default: -> { "" }
      attribute :local, Shale::Type::String, default: -> { "" }
    end

    class PhoneData < Shale::Mapper
      attribute :carrier, Shale::Type::String, default: -> { "" }
      attribute :contry, Contry
      attribute :format, Format

      attribute :location, Shale::Type::String, default: -> { "" }
      attribute :phone, Shale::Type::String, default: -> { "" }
      attribute :valid, Shale::Type::Boolean, default: -> { false }
    end

    class << self
      def phone(phonenumber, config_file)
        config = LibPhone::PhoneConfig.instance(config_file)

        p config

        res = nil
        begin
          res = HTTParty.get(
            "#{config.config.host}/#{phonenumber}",
            verify: config.config.verify
          )
        rescue StandartError => e
          puts e.message
        end

        if res.body.nil? || res.body.empty? && res.code != 200
          PhoneData.new
        else
          phone = res.body
          PhoneData.from_json(phone)
        end
      end
    end
  end
end
