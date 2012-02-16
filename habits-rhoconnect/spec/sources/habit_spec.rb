require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Habit" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Habit,'testuser'
    end

    it "should process Habit query" do
      pending
    end

    it "should process Habit create" do
      pending
    end

    it "should process Habit update" do
      pending
    end

    it "should process Habit delete" do
      pending
    end
  end  
end