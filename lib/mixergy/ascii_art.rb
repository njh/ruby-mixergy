# frozen_string_literal: true

require "pastel"

module Mixergy
  module AsciiArt
    # Draws an ASCII art hot water cylinder representing a charge level.
    # @param charge [Numeric] The charge percentage (0-100).
    # @param width [Integer] The width of the tank (default: 7).
    # @param height [Integer] The height of the tank (default: 10).
    # @return [String] The ASCII art representation of the tank.
    def self.draw_tank(charge, width: 7, height: 10)
      fill_height = (height * charge / 100.0).round
      pastel = Pastel.new

      tank = []
      tank << " ╭#{"─" * width}╮"
      height.times do |i|
        tank << if i < height - fill_height
          " │#{pastel.blue.on_blue(" ") * width}│"
        else
          " │#{pastel.red.on_red("█") * width}│"
        end
      end
      tank << " ╰#{"─" * width}╯"
      tank.join("\n")
    end
  end
end
