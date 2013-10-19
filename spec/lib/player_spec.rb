require_relative '../spec_helper'

describe Dish::Player do

  describe "default attributes" do
    it "must include httparty methods" do
      Dish::Player.should include HTTParty
    end

    it "must have the base url set to the Dribble API endpoint" do
      Dish::Player.base_uri.should eq('http://api.dribble.com')
    end
  end

  describe "GET profile" do
    before do
      VCR.insert_cassette 'player', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it "records the fixtures" do
      Dish::Player.get('/players/simplebits')
    end
  end

end