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
    puts 'calling query'
    habits = JSON.parse( RestClient.get("#{@base}/habits.json?auth_token=#{@token}", {:content_type => :json, :accept => :json}) )
    #parsed = JSON.parse(RestClient.get("#{@base}.json").body)                                                                                                                                                                                

    @result={}
    puts habits
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
    # TODO: Create a new record in your backend data source
    raise "Please provide some code to create a single record in the backend data source using the create_hash"
  end
 
  def update(update_hash)
    # TODO: Update an existing record in your backend data source
    raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end
 
  def delete(delete_hash)
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
end