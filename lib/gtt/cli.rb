module Gtt

  require 'optparse'
  require 'gtt/config'
  require 'gtt/tracker'
  require 'gtt/talker'
  require 'gtt/output'
  require 'gtt/commit'
  class Cli

    def parse

      response = {'message' => "Type -h for help"}

      OptionParser.new do |opts|
        opts.banner = <<-EOF.gsub(/^\s+/, "")
        gtt - Git Time Tracker
        Simple tool to track your working hours through git commits
        Usage: gtt [options] [message]
        EOF

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("--init", "Create new project config file") do
          Config.start
          response = {'ok' => true, 'message' => 'Project initiated'}
        end

        opts.on("--start-day [CHAT_MESSAGE]", "Start a new working day") do |chat_msg|
          response = tracker.start_day
          chat_msg ||= 'Morning o/'
          talker.send_message(chat_msg) if talker
        end

        opts.on("--end-day [CHAT_MESSAGE]", "End a working day") do |chat_msg|
          response = tracker.end_day
          chat_msg ||= 'heading out o/'
          talker.send_message(chat_msg) if talker
        end

        opts.on("-c", "--commit COMMIT_MESSAGE", "Create and commit Git task") do |commit_msg|
          commit = Commit.new(commit_msg, tracker)
          response = commit.save
        end

        opts.on("-t", "--start-task DESCRIPTION", "Start a non-Git task") do |description|
          response = tracker.start_task(description)
        end

        opts.on("-p", "--pause [CHAT_MESSAGE]", "Pause current task") do |chat_msg|
          response = tracker.pause_task
          chat_msg ||= 'brb'
          talker.send_message(chat_msg) if talker
        end

        opts.on("-r", "--resume [CHAT_MESSAGE]", "Resume current task") do |chat_msg|
          response = tracker.resume_task
          chat_msg ||= 'back'
          talker.send_message(chat_msg) if talker
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
          response = {'message' => opts}
        end

        opts.on("-v", "--version", "Show version number") do
          version = File.exist?('VERSION') ? File.read('VERSION') : ""
          response = {'message' => "v#{version}"}
        end

      end.parse!

      Output.new(response).to_terminal
    end

    private

    def tracker
      begin
        config = Config.load_project
        Tracker.new(config[:project], config[:token])
      rescue
        raise 'Invalid project credentials, run -h for info'
      end
    end

    def talker
      begin
        config = Config.load_campfire
        if config
          Talker.new(config[:token], config[:subdomain], config[:room_id])
        end
      rescue
        raise 'Invalid campfire credentials, run -h for info'
      end
    end

  end

end
