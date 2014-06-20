module TuitterHelper
  require 'oauth'
  require 'twitter'

  def self.sendTweet(mensaje)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = "lbLV1BULlskGkvcjdKxxEvuta"
      config.consumer_secret = "GPVRruykX0mQhoCfkBuL8ISgJA337xpWTa0jyLpmzYChTZb8Km"
      config.access_token        = "2559612822-93Bu3A4dCh7MxVezp47Mdx2oeshabbOKMFOGveq"
      config.access_token_secret = "HuPzsFPksro21pyQaxtW9nSwqfXaO6f1Vbg6rl16qXUT3"
    end
    client.update(mensaje)


  end

end
