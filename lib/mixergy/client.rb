# frozen_string_literal: true

require "faraday"
require "json"
require_relative "tank"

module Mixergy
  class Client
    API_ROOT = "https://www.mixergy.io/api/v2"

    def initialize
      @connection = Faraday.new(
        url: API_ROOT,
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }
      )
      @token = nil
    end

    def login(username, password)
      resp = @connection.post(
        "account/login",
        {username: username, password: password}.to_json
      )
      data = JSON.parse(resp.body)

      @token = data["token"]
      @connection.headers["Authorization"] = "Bearer #{@token}"
    end

    def tanks
      data = fetch_json("tanks")
      tank_list = data.dig("_embedded", "tankList") || []
      tank_list.map do |tank_data|
        Tank.new(tank_data)
      end
    end

    private

    def fetch_json(path)
      resp = @connection.get(path)
      unless resp.success?
        raise "HTTP Error: #{resp.status} - #{resp.body}"
      end
      begin
        JSON.parse(resp.body)
      rescue JSON::ParserError => e
        raise "Invalid JSON response: #{e.message}"
      end
    end
  end
end
