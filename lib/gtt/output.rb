module Gtt

  class Output

    def initialize(response)
      if response['ok']
        puts 'OK!'
      else
        puts "ERROR: #{response['message']}"
      end
    end

  end

end
