require 'open3'

module SpeedTest
  class SpeedData
    def initialize
      @info = info
    end

    def ping
      ping_string.split(' ')[1]
    end

    def ping_unit
      ping_string.split(' ')[2]
    end

    def download
      download_string.split(' ')[1]
    end

    def download_unit
      download_string.split(' ')[2]
    end

    def upload
      upload_string.split(' ')[1]
    end

    def upload_unit
      upload_string.split(' ')[2]
    end

    def time
      Time.now
    end

    private

    def info
      stdout, stderr, status = Open3.capture3('speedtest-cli --simple')
      stdout.split("\n")
    end

    def ping_string
      @info[0]
    end

    def download_string
      @info[1]
    end

    def upload_string
      @info[2]
    end
  end
end
