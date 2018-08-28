module SpeedTest
  class SpeedData
    def initialize
      @info = info
      @ping = ping
    end

    def info
      system('speedtest-cli --simple').split('\n')
    end

    def ping
      ping_string.split(' ')[1]
    end

    def download
      download_string.split(' ')[1]
    end

    private
    def ping_string
      info[0]
    end

    def download_string
      info[1]
    end
  end
end
