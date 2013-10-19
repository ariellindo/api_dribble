require_relative '../dish'

module Dish
  class Player
    include HTTParty

    attr_accessor :username

    base_uri 'http://api.dribbble.com'

    def initialize(username)
      self.username = username
    end

    def profile(force = false)
      force ? @profile = get_profile : @profile ||= get_profile
    end

    def method_missing(name, *args, &block)
      profile.has_key?(name.to_s) ? profile[name.to_s] : super
    end



    private

    def get_profile
      self.class.get "/players/#{self.username}"
    end

  end

end

def main
      player = Dish::Player.new('simplebits')
      puts player.profile
      puts player.username
      puts player.shots_count
    end

    main