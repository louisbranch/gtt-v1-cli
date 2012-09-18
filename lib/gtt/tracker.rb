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
      request(:post, :days)
    end

    def end_day
      request(:put, :days)
    end

    def commit_task(message, branch=nil)
      request(:post, :tasks, {
        message: message,
        type: :commit,
        branch: branch
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

    def request(method, resource, params={})
      body = { token: token }.merge(params)
      HTTParty.send(method, "#{url}/#{resource}", {body: body})
    end

  end

end
