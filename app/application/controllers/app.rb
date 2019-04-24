# frozen_string_literal: true

require 'roda'
require 'slim'
require 'pry'

module RandomRedirect
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css'

    route do |routing|
      routing.assets

      config = App.config

      # GET /
      routing.root do
        user_ip = request.ip
        seed = user_ip.gsub(/[^0-9]/, '').to_i

        redirect_url = get_random_url_based_on_prob(config.redirect_urls, seed)

        routing.redirect redirect_url
      end
    end

    def probs_sum(redirect_urls)
      probs = redirect_urls.map { |url| url['prob'] }
      probs.reduce(&:+)
    end 

    def get_random_url_based_on_prob(redirect_urls, seed)
      probs_sum = probs_sum(redirect_urls)
      num = Random.new(seed).rand(0..probs_sum)
      cumulative_prob = 0
    
      picked = redirect_urls.detect do |url|
        range = [ cumulative_prob, cumulative_prob+=url['prob'] ]
        num.between?(range[0], range[1])
      end
    
      picked['url']
    end
  end
end