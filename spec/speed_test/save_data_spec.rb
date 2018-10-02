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
      SpeedTest::SaveData.new(csv)
      expect(File.file?(csv)).to be true
    end
  end
end
