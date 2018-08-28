module SpeedTest
  class SpeedData
    def initialize
      @info = info
    end

    def info
      system('speedtest-cli --simple').split('\n')
    end
  end
end
