module SpeedTest
  class SpeedData
    def initialize
      @info = info
    end

    def info
      system('speedtest-cli --simple')
    end
  end
end
