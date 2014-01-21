module Gtt

  class Config

    def self.start
      File.open(".gtt", "w") do |f|
        f.write("# Uncomment the lines to configure the project\n")
        f.write("\n# Required:\n")
        f.write("# GTT_PROJECT=\n")
        f.write("# GTT_TOKEN=\n")
        f.write("\n# Optional:\n")
        f.write("# CAMPFIRE_TOKEN=\n")
        f.write("# CAMPFIRE_ROOM_ID=\n")
      end
    end

    def self.load_project
      config = File.read('.gtt')
      config.match(/^GTT_PROJECT=(.*)/)
      project = $1
      config.match(/^GTT_TOKEN=(.*)/)
      token = $1
      if token && project
        {project: project, token: token}
      end
    end

    def self.load_campfire
      config = File.read('.gtt')
      config.match(/^CAMPFIRE_TOKEN=(.*)/)
      token = $1
      config.match(/^CAMPFIRE_ROOM_ID=(.*)/)
      room_id = $1
      if token && room_id
        {token: token, room_id: room_id}
      end
    end

  end

end
