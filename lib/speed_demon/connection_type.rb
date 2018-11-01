require 'open3'

module SpeedDemon
  class ConnectionType
    def initialize
      @connection_info = connection_info
    end

    def connection_info
      stdout, stderr, status = Open3.capture3('ip link')
      stdout
    end

    def wireless?
      ip_link_status_array = connection_info.split("\n")
      ip_link_status_array.any? do |line|
        line.include?('state UP') && line.include?('wl')
      end
    end
  end
end
