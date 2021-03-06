# frozen_string_literal: true

require 'roda'
require 'econfig'

module RandRedirect
  # Environment configuration
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    configure do
      require 'redis'
      REDIS = Redis.new(url: App.config.REDIS_URL)
      REDIS.set('counter', 0)

      def self.REDIS
        REDIS
      end
    end
  end
end