require 'fileutils'
require 'csv'

module SpeedTest
  class SaveData
    def initialize(file)
      @csv_file_name = file
    end

    def create_csv
      CSV.open(@csv_file_name, 'a+', headers: true) do |line|
        # Write headers only if the file is new (empty)
        if line.eof?
          headers = ['Time',
                     'Ping (ms)',
                     'Download Speed (Mbit/s)',
                     'Upload Speed (Mbit/s)',
                     'wireless connection?']
          line << headers
        end
      end
    end
  end
end
