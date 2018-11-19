# frozen_string_literal: true

require "performa/version"
require "performa/logger"
require "performa/configuration"
require "performa/shell_helper"
require "performa/container_registry"
require "performa/environment"
require "performa/container_id"
require "performa/images"
require "performa/stages"
require "performa/coordinator"
require "performa/results_helper"

module Performa
  Error = Class.new(StandardError)
end
