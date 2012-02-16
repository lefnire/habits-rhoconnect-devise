require 'json'
require 'rest_client'

class Application < Rhoconnect::Base
  class << self
    def authenticate(username,password,session)
      
      response = RestClient.post "http://habits.local/tokens", {:email => username, :password => password}.to_json, :content_type => :json, :accept => :json
      puts "response: #{response}"

      if response.code == 200 || response.code == 201                                                                                                                                                                                                # save the data for later use in the source adapter
        key,value = "username:#{username}:token",JSON.parse(response)['token']
        puts "Storing authentication for key,value = #{key}, #{value}"
        Store.put_value(key,value)                                                                                                                                                                            
        return true                                                                                                                                                                                                           
      end                                                                                                                                                                                                                                    
      return false
    end
    
    # Add hooks for application startup here
    # Don't forget to call super at the end!
    def initializer(path)
      super
    end
    
    # Calling super here returns rack tempfile path:
    # i.e. /var/folders/J4/J4wGJ-r6H7S313GEZ-Xx5E+++TI
    # Note: This tempfile is removed when server stops or crashes...
    # See http://rack.rubyforge.org/doc/Multipart.html for more info
    # 
    # Override this by creating a copy of the file somewhere
    # and returning the path to that file (then don't call super!):
    # i.e. /mnt/myimages/soccer.png
    def store_blob(object,field_name,blob)
      super #=> returns blob[:tempfile]
    end
  end
end

Application.initializer(ROOT_PATH)

# Support passenger smart spawning/fork mode:
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We're in smart spawning mode.
      Store.db.client.reconnect
    else
      # We're in conservative spawning mode. We don't need to do anything.
    end
  end
end
