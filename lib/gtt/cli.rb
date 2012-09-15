module Gtt

  require 'optparse'
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

        opts.on("--init TOKEN", "Initiate a new project, grab token at http://gtt.heroku.com") do |token|
          print('Project initiated, config file created: .gtt', nil)
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
          response = tracker.commit_task(branch, commit_msg)
        end

        opts.on("--start-task NAME", "Start a non-Git task") do |name|
          response = tracker.start_task(name)
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

        opts.on("-l", "--log [LIMIT]", "Specify the number of entries (default 10)") do |n|
          response = n
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

      Output.new(response).to_terminal
    end

    private

    def tracker
      token = 'ABC' #Open config file
      Tracker.new(token)
    end

    def talker
      campfire_token = 'ABC' #Open config file
      campfire_room = 'ABC' #Open config file
      Talker.new(campfire_token, campfire_room)
    end

  end

end
