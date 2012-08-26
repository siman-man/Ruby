require 'twitter'
require 'pp'

Twitter.configure do |config|
    config.consumer_key = ''
    config.consumer_secret = ''
    config.oauth_token = ''
    config.oauth_token_secret = ''
end
Twitter.update("Hello World!")
pp Twitter.home_timeline
