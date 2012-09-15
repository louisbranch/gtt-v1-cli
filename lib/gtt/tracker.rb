module Gtt

  require 'httparty'
  class Tracker

    attr_reader :token, :url

    def initialize(token, url='http://gtt.heroku.com')
      @token, @url = token, url
    end

    def start_day
      request(:post, :days)
    end

    def end_day
      request(:put, :days)
    end

    def commit_task(message)
      request(:post, :tasks, {message: message, type: :commit})
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

    private

    def request(method, resource, params={})
      body = { token: token }.merge(params)
      HTTParty.send(method, "#{url}/#{resource}", {body: body})
    end

  end

end
