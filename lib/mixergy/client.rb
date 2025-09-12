# frozen_string_literal: true

require "faraday"
require "json"
require_relative "config"
require_relative "error"
require_relative "tank"
require_relative "status"

module Mixergy
  class Client
    API_ROOT = "https://www.mixergy.io/api/v2"

    # Create a new Mixergy API client.
    def initialize
      @connection = Faraday.new(
        url: API_ROOT
      ) do |faraday|
        faraday.request :json      # Automatically encode request bodies as JSON
        faraday.response :json     # Automatically parse response bodies as JSON
      end
    end

    # Loads configuration from ~/.mixergy and sets the API token if present.
    # @return [Mixergy::Config] the loaded config object
    def load_config
      @config ||= begin
        config = Mixergy::Config.new
        config.load
        # FIXME: find a better place to put this
        @connection.headers["Authorization"] = "Bearer #{config[:token]}"
        config
      end
    end

    # Authenticates with the Mixergy API and stores the token in the connection.
    # @param username [String] the username
    # @param password [String] the password
    # @return [String] the authentication token
    # @raise [Mixergy::Error] if login fails
    def login(username, password)
      resp = @connection.post(
        "account/login",
        {username: username, password: password}
      )
      data = resp.body

      if data["token"]
        @connection.headers["Authorization"] = "Bearer #{data["token"]}"
        data["token"]
      else
        raise Mixergy::Error, "Login failed (status: #{resp.status}, body: #{resp.body.inspect})"
      end
    end

    # Fetches all tanks associated with the account.
    # @return [Array<Tank>] list of Tank objects
    def tanks
      resp = @connection.get("tanks")
      tank_list = resp.body.dig("_embedded", "tankList") || []
      tank_list.map do |tank_data|
        Tank.new(tank_data)
      end
    end

    # Returns the default tank ID from config, or the first tank's ID.
    # @return [String, nil] the default tank ID
    def default_tank_id
      @default_tank_id ||= begin
        load_config
        @config[:default_tank_id] || tanks.first&.id
      end
    end

    # Fetches the latest status/measurement for a tank.
    # @param tank [Tank, nil] the tank object (optional)
    # @return [Status] the status object for the tank
    def status(tank = nil)
      tank_id = tank.id if tank.is_a?(Tank)
      tank_id = default_tank_id if tank_id.nil?
      resp = @connection.get("tanks/#{tank_id}/measurements/latest")
      Status.new(resp.body)
    end

    # Sets the target charge for a tank via the control endpoint.
    # @param percent [Integer] the target charge percentage
    # @param tank [Tank, String, nil] the Tank object or Tank Identifier (optional)
    # @return [Boolean] true if successful, false otherwise
    def set_charge(percent, tank = nil)
      tank_id = tank.id if tank.is_a?(Tank)
      tank_id = default_tank_id if tank_id.nil?
      resp = @connection.put("tanks/#{tank_id}/control", {charge: percent})
      resp.success?
    end
  end
end
