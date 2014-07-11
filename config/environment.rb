# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
NestJob::Application.initialize!

#elasticsearch初始化
development_settings = {log: true, trace: true} if Rails.env.development?
ELASTICSEARCH_CLIENT = Elasticsearch::Client.new({host: "54.250.192.6:9200"}.merge(development_settings||{}))
#weibo2
#Weibo2::Config.api_key = "2602316895"
#Weibo2::Config.api_secret = "f0f88b44f385aa02dfbde937e36bbb1b"
#Weibo2::Config.redirect_uri = "http://www.qingjs.com:3000/auth/weibo/callback"