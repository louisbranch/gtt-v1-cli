module Gtt

  require 'gtt/tracker'
  class Commit

    attr_reader :message, :tracker

    def initialize(message, tracker)
      @message, @tracker = message, tracker
    end

    def save
      tracker.commit_task(message, branch)
      commit!
    end

    private

    def commit!
      command = "git commit -m \"#{message}\""
      exec command
    end

    def branch
      branch = `git rev-parse --abbrev-ref HEAD`
      branch.gsub!(/\n/,'') if branch
    end

  end
end
