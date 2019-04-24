# frozen_string_literal: true

require 'dry/transaction'

module RandRedirect
  module Service
    # Return redirect url str
    # Usage: Service::AssignRedirectUrl.new.call(redirect_urls: arr, num: int)
    class AssignRedirectUrl
      include Dry::Transaction
      include Dry::Monads

      step :visitor_num_mod_prior_sum
      step :assign_url_based_on_mod

      private

      # input { redirect_urls:, num: }
      def visitor_num_mod_prior_sum(input)
        input[:cumulative_urls] = accumulate_urls_by_prior(input[:redirect_urls])
        
        prior_sum = input[:cumulative_urls][-1]['prior']
        input[:mod] = input[:num] % prior_sum

        Success(input)
      rescue
        Failure('Failed to take visitor number modulo prior sum')
      end

      # input { ..., cumulative_urls:, mod: }
      def assign_url_based_on_mod(input)
        match = input[:cumulative_urls].find { |url| input[:mod] < url['prior'] }
  
        Success(match['url'])
      rescue
        Failure('Failed to assign url based on mod')
      end

      def accumulate_urls_by_prior(urls)
        cumulative_prior = 0
        cumulative_urls = []

        urls.each do |url|
          cumulative_prior += url['prior']
          cumulative_urls << {'url' => url['url'], 'prior' => cumulative_prior}
        end

        cumulative_urls
      end
    end
  end
end