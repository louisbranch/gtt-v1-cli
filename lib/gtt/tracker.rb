module Gtt

  require 'httparty'
  class Tracker

    attr_reader :token, :url

    def initialize(project, token, url='http://localhost:9393')
      @token = token
      @url = "#{url}/projects/#{project}"
    end

    def start_day
      request(:put, "/days/#{date}", {start: time})
    end

    def end_day
      request(:put, "/days/#{date}", {end: time})
    end

    def commit_task(message, branch=nil)
      request(:post, "/days/#{date}/tasks", {
        message: message,
        type: :commit,
        branch: branch,
        end: time
      })
    end

    def start_task(message)
      request(:post, "/days/#{date}/tasks", {
        message: message,
        type: :task,
        end: time
      })
    end

    def pause_task
      request(:post, "/days/#{date}/breaks", {
        type: :pause,
        end: time
      })
    end

    def resume_task
      request(:post, "/days/#{date}/breaks", {
        type: :resume,
        end: time
      })
    end

    def stats
      request(:get, "/days/#{date}")
    end

    def logs(n=10)
      request(:get, '/logs', {limit: n})
    end

    private

    def request(method, path, params={})
      full_path = "#{url}#{path}/?token=#{token}"
      HTTParty.send(method, full_path, {body: params})
    end

    def date
      Time.now.strftime('%Y-%m-%d')
    end

    def time
      Time.now.strftime('%H:%M')
    end

  end

end
