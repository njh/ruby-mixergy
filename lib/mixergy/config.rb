# frozen_string_literal: true

require "yaml"
require "fileutils"

# Mixergy::Config handles loading and saving user configuration as a YAML file.
# The default config file is ~/.mixergy.
module Mixergy
  # Configuration handler for Mixergy CLI and API clients.
  # Loads and saves config as YAML, provides hash-like access.
  class Config
    # Default path for the config file (~/.mixergy)
    DEFAULT_CONFIG_PATH = File.expand_path("~/.mixergy")

    # @return [String] Path to the config file
    attr_reader :filepath
    # @return [Hash] The loaded config data
    attr_reader :data

    # Create a new Config object and load config from disk.
    # @param config_path [String] Optional path to config file
    def initialize(config_path = DEFAULT_CONFIG_PATH)
      @filepath = config_path
      @data = load
    end

    # Load config from disk.
    # @return [Hash] The loaded config data
    def load
      if File.exist?(@filepath)
        YAML.load_file(@filepath) || {}
      else
        {}
      end
    end

    # Save current config data to disk.
    # @return [void]
    def save
      File.write(@filepath, YAML.dump(@data))
    end

    # Get a config value by key.
    # @param key [String, Symbol]
    # @return [Object, nil] Value for the key
    def [](key)
      @data[key.to_s]
    end

    # Set a config value by key.
    # @param key [String, Symbol]
    # @param value [Object]
    # @return [void]
    def []=(key, value)
      @data[key.to_s] = value
    end
  end
end
