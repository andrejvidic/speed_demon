require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'if speedtest/cron_logs directory already exists,' do
    describe 'print warning message,' do
      let (:create_existing_directory) { FileUtils.mkdir_p(File.join(Dir.pwd, 'speedtest/cron_logs')) }
      let (:dir) { Dir.pwd }
      let (:file) { 'speedtest/cron_logs' }
      let(:cron_test_path) { File.join(dir, file) }

      before do
        create_existing_directory
      end

      after do
        # clean up
        dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'does not create a directory' do
        expect { system('speedtest_init') }
          .to output(include("speedtest/cron_logs exists, not created\n"))
          .to_stderr_from_any_process
      end
    end
  end

  describe 'if speedtest/cron_logs directory does not exist,' do
    describe 'create directory to current working directory' do
      let (:dir) { Dir.pwd }
      let (:file) { 'speedtest/cron_logs' }
      let(:cron_test_path) { File.join(dir, file) }

      after do
        # cleanup
        dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'creates a speedtest directory' do
        system('speedtest_init')
        expect(File.directory?(cron_test_path)).to be true
      end
    end
  end

  describe 'if speedtest/output directory already exists,' do
    describe 'print warning message,' do
      let (:create_existing_directory) { FileUtils.mkdir_p(File.join(Dir.pwd, 'speedtest/output')) }
      let (:dir) { Dir.pwd }
      let (:file) { 'speedtest/output' }
      let(:output_test_path) { File.join(dir, file) }

      before do
        create_existing_directory
      end

      after do
        # clean up
        dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'does not create a directory' do
        expect { system('speedtest_init') }
          .to output(include("speedtest/output exists, not created\n"))
          .to_stderr_from_any_process
      end
    end
  end

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
        dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'does not create a directory' do
        expect { system('speedtest_init') }
          .to output(include("speedtest exists, not created\n"))
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
        dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'creates a speedtest directory' do
        system('speedtest_init')
        expect(File.directory?(speed_test_path)).to be true
      end
    end
  end
end
