# frozen_string_literal: true

# Mixergy::Status represents the latest measurement/status of a tank.
# It provides access to charge, temperature, and other metrics.
module Mixergy
  # Represents the latest status/measurement for a Mixergy tank.
  class Status
    # @return [Float] Current charge percentage
    attr_reader :charge
    # @return [Float] Top temperature in Celsius
    attr_reader :top_temperature
    # @return [Float] Bottom temperature in Celsius
    attr_reader :bottom_temperature
    # @return [Float] Frequency in Hz
    attr_reader :frequency
    # @return [Float] Voltage in Volts
    attr_reader :voltage
    # @return [Float] Current in Amps
    attr_reader :current

    # Create a new Status object from API data.
    # @param data [Hash] API response data for latest measurement
    def initialize(data = {})
      @charge = data["charge"]
      @top_temperature = data["topTemperature"]
      @bottom_temperature = data["bottomTemperature"]
      @frequency = data["frequency"]
      @voltage = data["voltage"]
      @current = data["current"]
    end
  end
end
