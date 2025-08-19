# frozen_string_literal: true

module Mixergy
  class Tank
    attr_reader :id
    attr_reader :type
    attr_reader :firmware_version
    attr_reader :serial_number

    def initialize(data = nil)
      if data
        @id = data["id"]
        @type = data["type"]
        @firmware_version = data["firmwareVersion"]
        @serial_number = data["serialNumber"]
      end
    end
  end
end
