# frozen_string_literal: true

# Mixergy::Tank represents a physical Mixergy tank and its metadata.
# Provides access to tank ID, type, model, volume, firmware version, and serial number.
module Mixergy
  # Represents a Mixergy tank and its metadata.
  class Tank
    # @return [String] Unique tank ID
    attr_reader :id
    # @return [String] Tank type
    attr_reader :type
    # @return [String] Tank model code
    attr_reader :model
    # @return [Float] Tank volume in liters
    attr_reader :volume
    # @return [String] Firmware version
    attr_reader :firmware_version
    # @return [String] Serial number
    attr_reader :serial_number

    # Create a new Tank object from API data.
    # @param data [Hash, nil] API response data for the tank
    def initialize(data = nil)
      if data
        @id = data["id"]
        @type = data["type"]
        @model = data["tankModelCode"]
        @volume = data["volume"]
        @firmware_version = data["firmwareVersion"]
        @serial_number = data["serialNumber"]
      end
    end
  end
end
