# frozen_string_literal: true

require "yaml"
require "fileutils"

module Mixergy
  class Config
    DEFAULT_CONFIG_PATH = File.expand_path("~/.mixergy")

    attr_reader :filepath
    attr_reader :data

    def initialize(config_path = DEFAULT_CONFIG_PATH)
      @filepath = config_path
      @data = load
    end

    def load
      if File.exist?(@filepath)
        YAML.load_file(@filepath) || {}
      else
        {}
      end
    end

    def save
      File.write(@filepath, YAML.dump(@data))
    end

    def [](key)
      @data[key.to_s]
    end

    def []=(key, value)
      @data[key.to_s] = value
    end
  end
end
