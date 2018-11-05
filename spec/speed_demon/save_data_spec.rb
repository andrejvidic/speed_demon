require 'spec_helper'
require 'fileutils'

describe SpeedDemon::SaveData do
  describe 'for csv output,' do
    let(:base_dir) { '/tmp' }
    let(:speedtest) { "#{base_dir}/speedtest" }
    let(:output_dir) { File.expand_path('~/.local/share/speedtest') }
    let(:dirs) { [speedtest, output_dir] }
    let(:csv) do
      File.join(File.expand_path(output_dir), '/data.csv')
    end
    let(:create_output_directory) { FileUtils.mkdir_p(output_dir) }

    class MockSpeedData
      attr_reader :time, :ping, :download, :upload
      def initialize
        @time = Time.now
        @ping = 10
        @download = 45
        @upload = 20
      end
    end
    let(:measurements) { MockSpeedData.new }

    before do
      create_output_directory
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates a csv file in the specified output directory' do
      SpeedDemon::SaveData.execute(output_path: output_dir,
                                   data: measurements,
                                   wireless: true)
      expect(File.exist?(csv)).to be true
    end

    it 'the first line of the csv is a header' do
      SpeedDemon::SaveData.execute(output_path: output_dir,
                                   data: measurements,
                                   wireless: true)
      csv_first_line = IO.readlines(csv)[0]
      header_string = "Time,Ping (ms),Download Speed (Mbit/s),Upload Speed (Mbit/s),wireless connection?\n"
      expect(csv_first_line).to eq(header_string)
    end

    it 'correctly writes data to csv on 2nd line' do
      SpeedDemon::SaveData.execute(output_path: output_dir,
                                   data: measurements,
                                   wireless: false)
      csv_second_line = IO.readlines(csv)[1]
      data_string = "#{measurements.time},#{measurements.ping},#{measurements.download},#{measurements.upload},false\n"
      expect(csv_second_line).to eq(data_string)
    end
  end
end
