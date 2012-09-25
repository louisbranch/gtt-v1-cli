module Gtt

  require 'gtt/tracker'
  class Commit

    attr_reader :message, :tracker

    def initialize(message, tracker)
      @message, @tracker = message, tracker
    end

    def save
      if commit!
        tracker.commit_task(message, branch)
      else
        {error: true, message: 'Commit has failed!'}
      end
    end

    private

    def commit!
      command = "git commit -m \"#{message}\""
      system(command)
    end

    def branch
      branch = `git rev-parse --abbrev-ref HEAD`
      branch.gsub!(/\n/,'') if branch
    end

  end
end
