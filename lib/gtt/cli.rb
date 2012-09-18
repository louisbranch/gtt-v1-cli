module Gtt

  require 'optparse'
  require 'gtt/config'
  require 'gtt/tracker'
  require 'gtt/talker'
  require 'gtt/output'
  class Cli

    def parse

      response = "Type -h for help"

      OptionParser.new do |opts|
        opts.banner = <<-EOF.gsub(/^\s+/, "")
        gtt - Git Time Tracker
        Simple tool to track your working hours through git commits
        Usage: gtt [options] [message]
        EOF

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("--init", "Initiate a new project") do
          token = Tracker.create_project
          Config.save(token)
          response = 'Project initiated'
        end

        opts.on("--start-day [CHAT_MESSAGE]", "Start a new working day") do |chat_msg|
          response = tracker.start_day
          talker.send_message(chat_msg)
        end

        opts.on("--end-day [CHAT_MESSAGE]", "End a working day") do |chat_msg|
          response = tracker.end_day
          talker.send_message(chat_msg)
        end

        opts.on("-c", "--commit COMMIT_MESSAGE", "Create and commit Git task") do |commit_msg|
          branch = `git rev-parse --abbrev-ref HEAD`
          branch.gsub!(/\n/,'')
          response = tracker.commit_task(commit_msg, branch)
        end

        opts.on("--start-task DESCRIPTION", "Start a non-Git task") do |description|
          response = tracker.start_task(description)
        end

        opts.on("--end-task", "End a non-Git task") do
          response = tracker.end_task
        end

        opts.on("-p", "--pause [CHAT_MESSAGE]", "Pause current task") do |chat_msg|
          response = tracker.pause_task
          talker.send_message(chat_msg)
        end

        opts.on("-r", "--resume [CHAT_MESSAGE]", "Resume current task") do |chat_msg|
          response = tracker.pause_task
          talker.send_message(chat_msg)
        end

        opts.on("-s", "--stats", "Show working day stats") do
          response = tracker.stats
        end

        opts.on("-l", "--log [LIMIT]", "List the lastest changes (default to 10)") do |n|
          response = tracker.logs(n)
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on("-h", "--help", "Show this message") do
          response = opts
        end

        opts.on("-v", "--version", "Show version number") do
          version = File.exist?('VERSION') ? File.read('VERSION') : ""
          response = "v#{version}"
        end

      end.parse!

      Output.new(response)
    end

    private

    def tracker
      begin
        token = Config.load
        Tracker.new(token)
      rescue
        raise 'Invalid token, run -h for info'
      end
    end

    def talker
      campfire_token = 'ABC' #Open config file
      campfire_room = 'ABC' #Open config file
      Talker.new(campfire_token, campfire_room)
    end

  end

end
