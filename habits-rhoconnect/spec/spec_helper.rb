require 'rubygems'

# Set environment to test
ENV['RHO_ENV'] = 'test'
ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__),'..'))
Bundler.require(:default, ENV['RHO_ENV'].to_sym)

# Try to load vendor-ed rhoconnect, otherwise load the gem
begin
  require 'vendor/rhoconnect/lib/rhoconnect'
rescue LoadError
  require 'rhoconnect'
end

$:.unshift File.join(File.dirname(__FILE__), "..")
# Load our rhoconnect application
require 'application'
include Rhoconnect

require 'rhoconnect/test_methods'

# Monkey patch to fix the following issue:
# /usr/local/rvm/gems/ruby-1.8.7-p352/gems/rspec-core-2.6.4/lib/rspec/core/shared_example_group.rb:59:
# in `ensure_shared_example_group_name_not_taken': Shared example group 'SharedRhoconnectHelper' already exists (ArgumentError)
if RUBY_VERSION =~ /1.8/ 
  module RSpec
    module Core
      module SharedExampleGroup
      private
        def ensure_shared_example_group_name_not_taken(name)
        end
      end
    end
  end
end

shared_examples_for "SpecHelper" do
  include Rhoconnect::TestMethods
  
  before(:each) do
    Store.db.flushdb
    Application.initializer(ROOT_PATH)
  end  
end