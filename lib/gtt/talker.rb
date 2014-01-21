module Gtt

  require 'httparty'
  require 'json'
  class Talker

    attr_reader :auth, :url

    def initialize(token, room_id)
      @auth = {username: token, password: 'X'}
      @url = "https://api-campfire.hipchat.com/room/#{room_id}/speak.json"
    end

    def send_message(chat_message)
      params = {
        basic_auth: auth,
        body: {message: {body: chat_message}}.to_json,
        headers: {'Content-Type' => 'application/json'}
      }
      HTTParty.post(url, params)
    end

  end

end
