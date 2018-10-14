require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'with the -h or --help flag,' do
    it 'prints the help menu to STDOUT' do
      expect { system('speedtest_init -h') }
        .to output(include("Usage: speedtest_init [options]",
                           "    -h, --help                       Display this screen",
                           "    -o, --output PATH                specify path for output directory",
                           "    -l, --log PATH                   specify path for log directory",
                           "    -c, --cron PATH                  specify path for cron directory",
                           "    -f, --frequency TIME             specify logging frequency"))
        .to_stdout_from_any_process
    end
  end

  describe 'allow a user to specify CLI options,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest"}
    let (:custom_output_dir) { "#{base_dir}/output" }
    let (:custom_log_dir) { "#{base_dir}/log" }
    let (:custom_cron_dir) { "#{base_dir}/cron" }
    let (:custom_cron_file) { "#{custom_cron_dir}/cron.rb"}
    let (:dirs) { [speedtest, custom_output_dir, custom_log_dir, custom_cron_dir] }
    let (:options) { { base_dir: base_dir,
                       output: custom_output_dir,
                       log: custom_log_dir,
                       cron: custom_cron_dir } }
    let (:setup) { SpeedTest::Setup.new(options) }
    let (:set_current_directory) { Dir.chdir(base_dir) }
    let (:frequency_1hr) { ':hour' }
    let (:custom_cron_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

set :output, "#{custom_log_dir}/cron.log"

every #{frequency_1hr} do
  command 'ruby speed_test_check'
end
FILE
    end

    before do
      set_current_directory
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    describe 'create directories at locations other than /tmp/speedtest' do
      it 'creates output directory at /tmp/output' do
        system("speedtest_init --output #{custom_output_dir}")
        expect(File.directory?(custom_output_dir)).to be true
      end

      it 'creates log directory at /tmp/log' do
        system("speedtest_init --log #{custom_log_dir}")
        expect(File.directory?(custom_log_dir)).to be true
      end

      it 'creates cron directory at /tmp/cron' do
        system("speedtest_init --cron #{custom_cron_dir}")
        expect(File.directory?(custom_cron_dir)).to be true
      end
    end

    describe 'specify frequency at which speed is measured & saved' do
      it 'overrides default "15.minutes" to every hour (:hour)' do
        system("speedtest_init --frequency #{frequency_1hr} --cron #{custom_cron_dir} --log #{custom_log_dir}")
        expect(File.read(custom_cron_file)).to eq(custom_cron_file_contents)
      end
    end
  end

  describe 'from a directory, /tmp directory for example,' do
    describe 'without specifying a path or CLI options,' do
      let (:base_dir) { '/tmp' }
      let (:speedtest) { "#{base_dir}/speedtest"}
      let (:output_dir) { "#{base_dir}/speedtest/output" }
      let (:log_dir) { "#{base_dir}/speedtest/log" }
      let (:dirs) { [speedtest, output_dir, log_dir] }
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
        let (:log_dir) { "#{base_dir}/speedtest/log" }
        let (:dirs) { [speedtest, output_dir, log_dir] }
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
                               "#{log_dir} exists, not created\n",
                               "#{output_dir} exists, not created\n"))
            .to_stderr_from_any_process
        end
      end
    end
  end
end
