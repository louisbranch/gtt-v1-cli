module Gtt

  require 'optparse'
  class Cli

    def parse

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

        opts.on("--start-day [MESSAGE]", "Start a new working day") do |msg|
          print('Starting a new day', msg)
        end

        opts.on("--end-day [MESSAGE]", "End a working day") do |msg|
          print('Ending the day', msg)
        end

        opts.on("-c", "--commit MESSAGE", "Create and commit Git task") do |msg|
          branch = `git rev-parse --abbrev-ref HEAD`
          print("Commiting Git task on #{branch}", msg)
        end

        opts.on("--start-task MESSAGE", "Start a non-Git task") do |msg|
          print('Starting non-Git task', msg)
        end

        opts.on("--end-task", "End a non-Git task") do
          print('Ending non-Git task', nil)
        end

        opts.on("-p", "--pause [MESSAGE]", "Pause current task") do |msg|
          print('Taking a break', msg)
        end

        opts.on("-c", "--continue [MESSAGE]", "Continue current task") do |msg|
          print('Ending a break', msg)
        end

        opts.on("-s", "--stats", "Show working day stats") do
          print('Showing stats', nil)
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on("-h", "--help", "Show this message") do
          puts opts
        end

        opts.on("-v", "--version", "Show version number") do
          version = File.exist?('VERSION') ? File.read('VERSION') : ""
          puts "v#{version}"
        end

      end.parse!

    end

    def print(command, message)
      output = "[gtt] #{time} - #{command}"
      output += ": \"#{message}\"" if message
      puts output.gsub(/\n/, '')
    end

    def time
      Time.now.strftime('%T')
    end

  end

end
