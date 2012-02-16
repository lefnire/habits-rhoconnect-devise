require 'json'
require 'rest_client'

class Habit < SourceAdapter
  def initialize(source) 
    @base = 'http://habits.local'
    super(source)
  end
 
  def login
    @token = Store.get_value("username:#{current_user.login}:token")
    puts "token loaded for #{current_user.login}, token: #{@token}"
  end
 
  # Query your backend data source and assign the records 
  # to a nested hash structure called @result. For example:
  # @result = { 
  #   "1"=>{"name"=>"Acme", "industry"=>"Electronics"},
  #   "2"=>{"name"=>"Best", "industry"=>"Software"}
  # }
  def query(params=nil)
    puts "calling query #{@base}/habits.json?auth_token=#{@token}"
    habits = JSON.parse( RestClient.get("#{@base}/habits.json?auth_token=#{@token}", {:content_type => :json, :accept => :json}) )
    puts "query results: #{habits}"

    @result={}
    habits['habits'].each do |item|
      @result[item["id"].to_s] = item
    end if habits
    return @result
  end
 
  # Manipulate @result before it is saved, or save it
  # yourself using the Rhoconnect::Store interface.
  # By default, super is called below which simply saves @result
  def sync
    super
  end
 
  def create(create_hash)
    puts "calling create #{@base}/habits?auth_token=#{@token}"
    res = RestClient.post("#{@base}/habits?auth_token=#{@token}",{:habit => create_hash, :content_type => :json, :accept => :json})
    puts "create results: #{res}"

    # After create we are redirected to the new record.
    # We need to get the id of that record and return
    # it as part of create so rhosync can establish a link
    # from its temporary object on the client to this newly
    # created object on the server
    JSON.parse( res.body )["id"]
  end

  def update(update_hash)
    obj_id = update_hash['id']
    update_hash.delete('id')
    puts "calling update #{@base}/habits/#{obj_id}?auth_token=#{@token}"
    res = RestClient.put("#{@base}/habits/#{obj_id}?auth_token=#{@token}", {:habit => update_hash, :content_type => :json, :accept => :json})
    puts "update results: #{res}"
  end

  def delete(delete_hash)
    if delete_hash['id']
      puts "calling delete"
      puts "Calling destroy on #{@base}/habits/#{delete_hash['id']}?auth_token=#{@token}"
      res = RestClient.delete("#{@base}/habits/#{delete_hash['id']}?auth_token=#{@token}")
    else
      puts "no delete_hash['id']"
    end
  end

  def logoff
    # TODO: Logout from the data source if necessary
  end
end