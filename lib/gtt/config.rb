module Gtt

  class Config

    def self.save_token(token)
      File.open(".gtt", "w") do |f|
        f.write("GTT_TOKEN=#{token}")
      end
    end

    def self.load_token
      config = File.read('.gtt')
      config.match(/GTT_TOKEN=(.*)/)
      $1
    end

    def self.load_campfire
      config = File.read('.gtt')
      config.match(/CAMPFIRE_TOKEN=(.*)/)
      token = $1
      config.match(/CAMPFIRE_SUBDOMAIN=(.*)/)
      subdomain = $1
      config.match(/CAMPFIRE_ROOM_ID=(.*)/)
      room_id = $1
      {token: token, subdomain: subdomain, room_id: room_id}
    end

  end

end
