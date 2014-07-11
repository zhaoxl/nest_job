Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  #provider :weibo, "2602316895", "f0f88b44f385aa02dfbde937e36bbb1b"
  provider :qq, "101138342", "5bad82442787f2d36ec2ab66fadbcee8"
end
