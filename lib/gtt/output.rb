module Gtt

  require 'rainbow'
  class Output

    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_terminal
      if response['ok']
        output = render_success(response)
      elsif response['error']
        output = render_error(response)
      else
        output = response['message']
      end
      puts output
    end

    private

    def render_success(response)
      output = 'OK! '.color(:green)
      if response['message']
        output += response['message'].to_s
      end
      output
    end

    def render_error(response)
      output = "ERROR: ".color(:red)
      if response['message']
        output += response['message'].to_s
      end
      output
    end

  end

end
