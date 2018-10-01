require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'allowing a user to specify location of the output directory,' do
    describe 'using --output PATH,' do
      let (:base_dir) { '/tmp' }
      let (:output_dir) { "#{base_dir}/output" }

      let (:command) { "speedtest_init --output #{output_dir}" }
      let (:dirs) { ["#{base_dir}/speedtest", output_dir, "#{base_dir}/speedtest/cron_logs"] }
      let (:set_current_directory) { Dir.chdir(base_dir) }

      before do
        set_current_directory
      end

      after do
        # cleanup
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
      end

      it 'creates output directory at /tmp/output' do
        system(command)
        expect(File.directory?(output_dir)).to be true
      end
    end
  end

  describe 'allowing a user to navigate to any directory, /tmp directory for example,' do
    describe 'and create all speedtest directories at this location' do
      let (:base_dir) { '/tmp' }
      let (:dirs) { ["#{base_dir}/speedtest", "#{base_dir}/speedtest/log", "#{base_dir}/speedtest/output"] }
      let (:set_current_directory) { Dir.chdir(base_dir) }

      before do
        set_current_directory
      end

      after do
        # cleanup
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir)}
      end

      it 'creates a speedtest directory' do
        system('speedtest_init')
        dirs.each do |dir|
          expect(File.directory?(dir)).to be true
        end
      end
    end
  end

  describe 'if speedtest directories already exists,' do
    describe 'print warning messages,' do

      let (:base_dir) { '/tmp' }
      let (:dirs) { ["#{base_dir}/speedtest", "#{base_dir}/speedtest/log", "#{base_dir}/speedtest/output"] }
      let (:set_current_directory) { Dir.chdir(base_dir) }
      let (:create_existing_directories) { dirs.each { |dir| FileUtils.mkdir_p(dir) } }

      before do
        set_current_directory
        create_existing_directories
      end

      after do
        # clean up
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
      end

      it 'does not create a directory' do
        expect { system('speedtest_init') }
          .to output(include("/tmp/speedtest exists, not created\n",
                             "/tmp/speedtest/log exists, not created\n",
                             "/tmp/speedtest/output exists, not created\n"))
          .to_stderr_from_any_process
      end
    end
  end
end
