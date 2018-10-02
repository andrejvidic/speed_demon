require 'fileutils'
require 'csv'

module SpeedTest
  class SaveData
    def initialize(file)
      @csv_file_name = file
      create_csv
    end

    def create_csv
      CSV.open(@csv_file_name, 'a+', headers: true) do |csv|
      end
    end
  end
end
