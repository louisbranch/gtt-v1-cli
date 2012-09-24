module Gtt

  require 'httparty'
  class Tracker

    attr_reader :token, :url

    def initialize(token, url='http://localhost:9393')
      @token, @url = token, url
    end

    def self.create_project
      token = HTTParty.post('http://localhost:9393/projects')
      token
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
      request(:post, :tasks, {message: message})
    end

    def pause_task
      request(:put, :tasks, {type: :pause})
    end

    def resume_task
      request(:put, :tasks, {type: :resume})
    end

    def end_task
      request(:put, :tasks, {type: :end})
    end

    def stats
      request(:get, :stats)
    end

    def logs(n=10)
      request(:get, :logs, {limit: n})
    end

    private

    def request(method, path, params={})
      body = { token: token }.merge(params)
      full_path = url + '/projects/scaffold' + path
      HTTParty.send(method, full_path, {body: body})
    end

    def date
      Time.now.strftime('%Y-%m-%d')
    end

    def time
      Time.now.strftime('%H:%M')
    end

  end

end
