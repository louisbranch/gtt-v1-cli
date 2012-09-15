module Gtt

  class Output

    attr_reader :json_response

    def initialize(json_response)
      @json_response = json_response
    end

    def to_terminal
      puts json_response
    end

  end

end
