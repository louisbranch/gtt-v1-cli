module Gtt

  require 'rainbow'
  class Output

    def initialize(response)
      if response['ok']
        puts 'OK!'.color(:green)
      else
        error = "ERROR:".color(:red)
        puts "#{error} #{response['message']}"
      end
    end

  end

end
