
redirect_urls = [{url: "First", prob: 100}, 
                 {url: "Second", prob: 100}, 
                 {url: "Third", prob: 50}, 
                 {url: "Forth", prob: 50}]

def probs_sum(redirect_urls)
  probs = redirect_urls.map { |pair| pair[:prob] }
  probs.reduce(&:+)
end

def int_prob(redirect_urls, seed)
  probs_sum = probs_sum(redirect_urls)
  num = Random.new(seed).rand(0..probs_sum)
  cumulative_prob = 0

  picked = redirect_urls.detect do |item|
    range = [ cumulative_prob, cumulative_prob+=item[:prob] ]
    num.between?(range[0], range[1])
  end

  picked[:url]
end


redirect_urls_float = [{url: "First", prob: 0.33}, 
                       {url: "Second", prob: 0.33}, 
                       {url: "Third", prob: 0.165}, 
                       {url: "Forth", prob: 0.165}]

def float_prob(redirect_urls, seed)
  num = Random.new(seed).rand
  cumulative_prob = 0

  picked = redirect_urls.detect do |item|
    range = [ cumulative_prob, cumulative_prob+=item[:prob] ]
    num.between?(range[0], range[1])
  end

  # 'picked' could be nil if probs sum < 1 and num == 0.9998989
  picked.nil? ? redirect_urls[-1][:url] : picked[:url]
end


def test_ratio_with_ipseed(func, params, times)
  func_result = {}
  times.times do |i|
    result = func.call(params, rand(100000..10000000))
    func_result[result] ? func_result[result] += 1 :
                          func_result[result] = 1
  end

  func_result
end

times = 300
test_ratio_with_ipseed(method(:float_prob), redirect_urls_float, times)
test_ratio_with_ipseed(method(:int_prob), redirect_urls, times)


# def int_prob(redirect_urls)
#   probs_sum = probs_sum(redirect_urls)
#   num = rand(0..probs_sum)
#   cumulative_prob = 0

#   picked = redirect_urls.detect do |item|
#     range = [ cumulative_prob, cumulative_prob+=item[:prob] ]
#     num.between?(range[0], range[1])
#   end

#   picked[:url]
# end


# def float_prob(redirect_urls)
#   num = rand
#   cumulative_prob = 0

#   picked = redirect_urls.detect do |item|
#     range = [ cumulative_prob, cumulative_prob+=item[:prob] ]
#     num.between?(range[0], range[1])
#   end

#   # 'picked' could be nil if probs sum < 1 and num == 0.9998989
#   picked.nil? ? redirect_urls[-1][:url] : picked[:url]
# end


# def test_ratio(func, params, times)
#   func_result = {}
#   times.times do |i|
#     result = func.call(params)
#     func_result[result] ? func_result[result] += 1 :
#                           func_result[result] = 1
#   end

#   func_result
# end

# times = 300
# test_ratio(method(:float_prob), redirect_urls_float, times)
# test_ratio(method(:int_prob), redirect_urls, times)

