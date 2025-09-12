# frozen_string_literal: true

# Mixergy::Error is the base exception class for all Mixergy-related errors.
# Raise this for API, configuration, or client errors.
module Mixergy
  # Base exception class for Mixergy errors.
  # All custom errors should inherit from this.
  class Error < StandardError; end
end
