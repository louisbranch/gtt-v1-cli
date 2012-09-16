module Gtt

  class Config

    def self.save(token)
      File.open(".gtt", "w") do |f|
        f.write("GTT_TOKEN=#{token}")
      end
    end

    def self.load
      config = File.read('.gtt')
      config.match(/GTT_TOKEN=(.*)/)
      $1
    end

  end

end
