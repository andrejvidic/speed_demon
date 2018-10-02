require 'spec_helper'
require 'fileutils'

describe SpeedTest::SaveData do
  describe 'for csv output,' do
    let (:dir) { '/tmp/speedtest/output' }
    let (:csv) { "#{dir}/speed_data.csv" }
    let (:create_output_directory) { FileUtils.mkdir_p(dir) }

    before do
      create_output_directory
    end

    after do
      # cleanup
      FileUtils.rm_rf(dir) if File.directory?(dir)
    end

    it 'creates a csv file in the specified output directory' do
      SpeedTest::SaveData.new(csv).create_csv
      expect(File.exist?(csv)).to be true
    end

    it 'the first line of the csv is a header' do
      SpeedTest::SaveData.new(csv).create_csv
      csv_first_line = IO.readlines(csv)[0]
      header_string = "Time,Ping (ms),Download Speed (Mbit/s),Upload Speed (Mbit/s),wireless connection?\n"
      expect(csv_first_line).to eq(header_string)
    end
  end
end
