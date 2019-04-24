# frozen_string_literal: true

require 'roda'
require 'econfig'
require 'redis'

module RandomRedirect
  # Environment configuration
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    redis = Redis.new(url: ENV['REDIS_URL'])
    binding.pry
  end
end