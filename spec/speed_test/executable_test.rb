require 'spec_helper'
require 'fileutils'


  describe 'if speedtest directory does not exist,' do
    describe 'create directory to current working directory' do
      let (:dir) { Dir.pwd }
      let (:file) { 'speedtest' }
      let(:speed_test_path) { File.join(dir, file) }

      after do
        # cleanup
        FileUtils.rm_rf(speed_test_path) if File.directory?(speed_test_path)
      end

      it 'creates a speedtest directory' do
        puts "speed_test_path: #{speed_test_path}"
        system('speedtest_init')
        expect(File.directory?(speed_test_path)).to be true
      end
    end
  end
end
