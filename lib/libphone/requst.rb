# frozen_string_literal: true

require "httparty"

# send data to the libphone api server and get the responce
module LibPhone
  class Phone
    attr_reader :carrier, :contry, :format, :location, :phone, :valid

    def initialize(phonenumber)
      @carrier = {
        'code': "",
        'name': "",
        'prefix': ""
      }
      @contry = ""
      @format = {
        'international': "",
        'local': ""
      }
      @location = ""
      @phone = ""
      @valid = ""

      Phone.informations(phonenumber) unless phonenumber.nil?
    end

    class << self
      def informations(phonenumber)
        res = nil
        begin
          res = HTTParty.get("https://phone.osma-aufzuege.de/#{phonenumber}", verify: false)
        rescue StandartError => e
          puts e.message
        end

        return unless !res.nil? && res.code == 200

        phone = res.body
        phone["location"].force_encoding("iso-8859-1").encode("utf-8")
        data = JSON.parse(phone)

        @carrier = data["carrier"]
        @contry = data["contry"]
        @format = data["format"]
        @location = data["location"]
        @phone = data["phone"]
        @valid = data["valid"]
      end
    end
  end
end
