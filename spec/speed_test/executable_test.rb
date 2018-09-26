require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'if speedtest/output directory does not exist,' do
    describe 'create directory to current working directory' do
      let (:dir) { Dir.pwd }
      let (:file) { 'speedtest/output' }
      let(:output_test_path) { File.join(dir, file) }

      after do
        # cleanup
        dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'creates a speedtest directory' do
        system('speedtest_init')
        expect(File.directory?(output_test_path)).to be true
      end
    end
  end

  describe 'if speedtest directory already exists,' do
    describe 'print warning message,' do
      let (:create_existing_directory) { FileUtils.mkdir_p(File.join(Dir.pwd, 'speedtest')) }
      let (:dir) { Dir.pwd }
      let (:file) { 'speedtest' }
      let(:speed_test_path) { File.join(dir, file) }

      before do
        create_existing_directory
      end

      after do
        # clean up
        FileUtils.rm_rf(speed_test_path) if File.directory?(speed_test_path)
      end

      it 'does not create a directory' do
        expect { system('speedtest_init') }
          .to output("speedtest directory exists, not created\n")
          .to_stderr_from_any_process
      end
    end
  end

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
