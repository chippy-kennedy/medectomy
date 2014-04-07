module DisqusHelper
    require 'rubygems'
    require 'base64'
    require 'cgi'
    require 'openssl'
    require "json"
     
    DISQUS_SECRET_KEY = 'w9ZlSbxZEzmdzEeTfGrivqsRFhzXpTX5YlcFK47hOW0gFaXdc6j0A6dJC1bjgs3o'
    DISQUS_PUBLIC_KEY = '1L7BHGrWA9w5JMfGZYmht5h4c4vWfK1Ye1OVLOUmq3RI0RKcJgD6fP1XmCQp4vAn'
     
    def get_disqus_sso_message(user)
        # create a JSON packet of our data attributes
        data = 	{
          'id' => user.id,
          'username' => "#{user.first_name} #{user.last_name}",
          'email' => user.email
        }.to_json
     
        # encode the data to base64
        message  = Base64.encode64(data).gsub("\n", "")
        # generate a timestamp for signing the message
        timestamp = Time.now.to_i
        # generate our hmac signature
        sig = OpenSSL::HMAC.hexdigest('sha1', DISQUS_SECRET_KEY, '%s %s' % [message, timestamp])
     
        # return a script tag to insert the sso message
        return "#{message} #{sig} #{timestamp}";
    end

    def get_disqus_public_key
        return DISQUS_PUBLIC_KEY
    end
end