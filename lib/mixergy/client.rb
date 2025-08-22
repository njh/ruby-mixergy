# frozen_string_literal: true

require "faraday"
require "json"
require_relative "config"
require_relative "error"
require_relative "tank"

module Mixergy
  class Client
    API_ROOT = "https://www.mixergy.io/api/v2"

    def initialize
      @connection = Faraday.new(
        url: API_ROOT
      ) do |faraday|
        faraday.request :json      # Automatically encode request bodies as JSON
        faraday.response :json     # Automatically parse response bodies as JSON
      end
    end

    def load_config
      @config ||= begin
        config = Mixergy::Config.new
        config.load
        # FIXME: find a better place to put this
        @connection.headers["Authorization"] = "Bearer #{config[:token]}"
        config
      end
    end

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

    def tanks
      resp = @connection.get("tanks")
      tank_list = resp.body.dig("_embedded", "tankList") || []
      tank_list.map do |tank_data|
        Tank.new(tank_data)
      end
    end

    def default_tank_id
      @default_tank_id ||= begin
        load_config
        @config[:default_tank_id] || tanks.first&.id
      end
    end
  end
end
