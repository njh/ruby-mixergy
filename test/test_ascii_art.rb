# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/mixergy/ascii_art"

class TestAsciiArt < Minitest::Test
  def test_draw_tank_full_no_colour
    ENV["NO_COLOR"] = "1"
    art = Mixergy::AsciiArt.draw_tank(100, width: 7, height: 10)
    assert_equal 12, art.lines.count
    expected_tank = [
      " ╭───────╮",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " ╰───────╯"
    ]
    expected_tank.each_with_index do |expected, idx|
      assert_equal expected, art.lines[idx].chomp, "Line #{idx + 1} does not match"
    end
  end

  def test_draw_tank_half_full_no_colour
    ENV["NO_COLOR"] = "1"
    art = Mixergy::AsciiArt.draw_tank(50, width: 7, height: 10)
    assert_equal 12, art.lines.count
    expected_tank = [
      " ╭───────╮",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " │███████│",
      " ╰───────╯"
    ]
    expected_tank.each_with_index do |expected, idx|
      assert_equal expected, art.lines[idx].chomp, "Line #{idx + 1} does not match"
    end
  end

  # This test ensures that rounding works as expected
  def test_draw_tank_round_up_no_colour
    ENV["NO_COLOR"] = "1"
    art = Mixergy::AsciiArt.draw_tank(29, width: 7, height: 10)
    assert_equal 12, art.lines.count
    expected_tank = [
      " ╭───────╮",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │███████│",
      " │███████│",
      " │███████│",
      " ╰───────╯"
    ]
    expected_tank.each_with_index do |expected, idx|
      assert_equal expected, art.lines[idx].chomp, "Line #{idx + 1} does not match"
    end
  end

  def test_draw_tank_empty_no_colour
    ENV["NO_COLOR"] = "1"
    art = Mixergy::AsciiArt.draw_tank(0, width: 7, height: 10)
    assert_equal 12, art.lines.count
    expected_tank = [
      " ╭───────╮",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " │       │",
      " ╰───────╯"
    ]
    expected_tank.each_with_index do |expected, idx|
      assert_equal expected, art.lines[idx].chomp, "Line #{idx + 1} does not match"
    end
  end
end
