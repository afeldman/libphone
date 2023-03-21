# frozen_string_literal: true

require "countries"

require_relative "libphone/version"
require_relative "libphone/request"

module LibPhone
  def phone_informations(config_file, phonenumber, country = "DE")
    c = ISO3166::Country.find_country_by_alpha2(country) unless country.nil?

    phonenumber = if !c.nil? && phonenumber.start_with?("0")
                    "+#{c.country_code}#{phonenumber[1..]}"
                  else
                    phonenumber
                  end

    LibPhone::Phone.phone(phonenumber, config_file)
  end

  module_function :phone_informations
end
