# frozen_string_literal: true

module Mixergy
  class Status
    attr_reader :charge
    attr_reader :top_temperature
    attr_reader :bottom_temperature
    attr_reader :frequency
    attr_reader :voltage
    attr_reader :current

    def initialize(data={})
      @charge = data["charge"]
      @top_temperature = data["topTemperature"]
      @bottom_temperature = data["bottomTemperature"]
      @frequency = data["frequency"]
      @voltage = data["voltage"]
      @current = data["current"]
    end
  end
end
