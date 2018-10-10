require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'with the -h or --help flag,' do
    it 'prints the help menu to STDOUT' do
      expect { system('speedtest_init -h') }
        .to output(include("Usage: speedtest_init [options]",
                           "    -h, --help                       Display this screen",
                           "    -o, --output PATH                specify path for output directory",
                           "    -l, --log PATH                   specify path for log directory"))
        .to_stdout_from_any_process
    end
  end

  describe 'allowing a user to specify location of all directories,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest"}
    let (:output_dir) { "#{base_dir}/output" }
    let (:cron_log_dir) { "#{base_dir}/log" }
    let (:dirs) { [speedtest, output_dir, cron_log_dir] }
    let (:set_current_directory) { Dir.chdir(base_dir) }

    before do
      set_current_directory
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    describe 'create directories at locations other than /tmp/speedtest' do
      it 'creates output directory at /tmp/output' do
        system("speedtest_init --output #{output_dir}")
        expect(File.directory?(output_dir)).to be true
      end

      it 'creates cron_log directory at /tmp/log' do
        system("speedtest_init --log #{cron_log_dir}")
        expect(File.directory?(cron_log_dir)).to be true
      end
    end
  end

  describe 'from a directory, /tmp directory for example,' do
    describe 'without specifying a path or CLI options,' do
      let (:base_dir) { '/tmp' }
      let (:speedtest) { "#{base_dir}/speedtest"}
      let (:output_dir) { "#{base_dir}/speedtest/output" }
      let (:cron_log_dir) { "#{base_dir}/speedtest/log" }
      let (:dirs) { [speedtest, output_dir, cron_log_dir] }
      let (:set_current_directory) { Dir.chdir(base_dir) }

      before do
        set_current_directory
      end

      after do
        # cleanup
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
      end

      it 'creates all speedtest directories using default locations for the output & log directories' do
        system('speedtest_init')
        dirs.each do |dir|
          expect(File.directory?(dir)).to be true
        end
      end
    end

    describe 'if speedtest directories already exists,' do
      describe 'print warning messages,' do

        let (:base_dir) { '/tmp' }
        let (:speedtest) { "#{base_dir}/speedtest"}
        let (:output_dir) { "#{base_dir}/speedtest/output" }
        let (:cron_log_dir) { "#{base_dir}/speedtest/log" }
        let (:dirs) { [speedtest, output_dir, cron_log_dir] }
        let (:create_existing_directories) { dirs.each { |dir| FileUtils.mkdir_p(dir) } }

        before do
          create_existing_directories
        end

        after do
          # clean up
          dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
        end

        it 'does not create a directory' do
          expect { system("speedtest_init #{base_dir}") }
            .to output(include("#{speedtest} exists, not created\n",
                               "#{cron_log_dir} exists, not created\n",
                               "#{output_dir} exists, not created\n"))
            .to_stderr_from_any_process
        end
      end
    end
  end
end
