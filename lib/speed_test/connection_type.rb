module SpeedTest
  class ConnectionType
    def initialize
      @connection_info = connection_info
    end

    def connection_info
      system('ip link')
    end

    def wireless?
      true
    end
  end
end
