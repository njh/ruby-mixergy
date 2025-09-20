#!/usr/bin/env ruby
# frozen_string_literal: true

#
# A script to schedule temperature changes for a Mixergy hot water cylinder
# This allows you to set a higher temperature during off-peak hours, when electricy is cheaper,
# Allowing you to use your hot water cylinder as an energy storage device.
#
# You can run this script periodically using cron or a similar scheduler:
# 0,30 * * * * /path/to/schedule-hwc-temperature.rb
#
# I run it every 30 minutes, in case it misses a time slot.
#
# Make sure you have run `mixergy login` to authenticate before using this script.
#

require "mixergy"
require "time"

# Set your desired times and temperatures here
NORMAL_TEMP = 42
BOOST_TEMP = 55
BOOST_START = "00:30"
BOOST_END = "05:30"

client = Mixergy::Client.new
client.load_config

# Determines if the current time falls within the defined boost period.
#
# The boost period is defined by the constants BOOST_START and BOOST_END, which
# represent the start and end times (as strings, e.g., "23:00" and "05:00").
# Handles boost periods that span overnight (e.g., start at 23:00 and end at 05:00 the next day).
#
# @param now [Time] The time to check (defaults to the current time if not provided).
# @return [Boolean] true if the given time is within the boost period, false otherwise.
def boost_period?(now = Time.now)
  today = now.strftime("%Y-%m-%d")
  start_time = Time.parse("#{today} #{BOOST_START}")
  end_time = Time.parse("#{today} #{BOOST_END}")
  # Handle overnight boost period (e.g., 23:00 to 05:00)
  if end_time < start_time
    # If now is before the start time, treat end_time as tomorrow
    if now < start_time
      end_time = Time.parse("#{(now + 86400).strftime("%Y-%m-%d")} #{BOOST_END}")
    else
      # Otherwise, end_time is today + 1 day
      end_time += 86400
    end
  end
  now >= start_time && now < end_time
end

temp = boost_period? ? BOOST_TEMP : NORMAL_TEMP
if client.target_temperature != temp
  if client.set_target_temperature(temp)
    puts "Set tank target temperature to #{temp}°C"
  else
    warn "Failed to set tank target temperature"
    exit 1
  end
end
