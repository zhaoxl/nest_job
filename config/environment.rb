# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
NestJob::Application.initialize!

#elasticsearch初始化
development_settings = {log: true, trace: true} if Rails.env.development?
Post.__elasticsearch__.client = Elasticsearch::Client.new({host: "54.250.192.6:9200"}.merge(development_settings||{}))