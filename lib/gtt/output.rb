module Gtt

  require 'rainbow'
  class Output

    def initialize(response)
      if response['ok']
        output = render_success(response)
      elsif response['error']
        output = render_error(response)
      else
        output = 'Unknown message'.color(:yellow)
      end
      puts output
    end

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
