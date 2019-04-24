# frozen_string_literal: true

require 'roda'
require 'slim'
require 'pry'

module RandRedirect
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css'

    route do |routing|
      routing.assets

      config = App.config

      # GET /
      routing.root do
        visitor_num = App.REDIS.get('counter').to_i

        res = Service::AssignRedirectUrl.new.call(redirect_urls: config.redirect_urls, 
                                                  num: visitor_num)
        if res.success?
          redirect_url = res.value!
        else
          puts res.failure
        end

        App.REDIS.incr('counter')
        view 'waiting', locals: { redirect_url: redirect_url }
      end
    end
  end
end