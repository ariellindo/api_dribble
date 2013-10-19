require_relative '../spec_helper'

describe Dish::Player do

  describe "default attributes" do
    it "must include httparty methods" do
      Dish::Player.should include HTTParty
    end

    it "must have the base url set to the Dribble API endpoint" do
      Dish::Player.base_uri.should eq('http://api.dribbble.com')
    end
  end

  describe "default instance attributes" do
    let(:player) { Dish::Player.new('simplebits') }

    it "must have and id attribute" do
      player.should respond_to :username
    end

    it "must have the right id" do
      player.username.should eq('simplebits')
    end
  end

  describe "GET profile" do
    let(:player) { Dish::Player.new('simplebits') }

    before do
      VCR.insert_cassette 'player', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it "records the fixture" do
      Dish::Player.get('/players/simplebits')
    end

    it "must have a profile method" do
      player.should respond_to :profile
    end

    it "must parse the api response from json to hash" do
      player.profile.should be_instance_of Hash
    end

    it "must perform the request and get the data" do
      player.profile["username"].should eq('simplebits')
    end

    describe "dynamic attributes" do
      before do
        player.profile
      end

      it "must return the attribute value if present in the profile" do
        player.id.should eq(1)
      end

      it "must raise method missing if attribute is not present" do
        lambda { player.foo_attribute }.should raise_error(NoMethodError)
      end
    end

    describe "caching" do
      # webmock disable network conection after fetching
      # the profile
      before do
        player.profile
        stub_request(:any, /api.dribbble.com/).to_timeout
      end

      it "must cache the profile" do
        player.profile.should be_instance_of Hash
      end

      it "must refresh the profile if forced" do
        lambda { player.profile(true) }.should raise_error(Timeout::Error)
      end


    end
  end

end