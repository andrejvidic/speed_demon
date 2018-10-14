require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'with the -h or --help flag,' do
    it 'prints the help menu to STDOUT' do
      expect { system('speedtest_init -h') }
        .to output(include("Usage: speedtest_init [options]",
                           "    -h, --help                       Display this screen",
                           "    -s, --setup-default              specify true/false, yes/no to setup speedtest to default directories",
                           "    -o, --custom-output PATH         specify custom path for output directory",
                           "    -l, --custom-log PATH            specify custom path for log directory",
                           "    -c, --custom-cron PATH           specify custom path for cron directory",
                           "    -f, --custom-frequency TIME      specify custom speedtest measuring frequency"))
        .to_stdout_from_any_process
    end
  end

  describe 'supplying at least one custom option,' do
    let (:base_dir) { '/tmp' }
    let (:custom_output_dir) { "#{base_dir}/output" }
    let (:default_output_dir) { "~/.local/share/speedtest/output" }
    let (:custom_log_dir) { "#{base_dir}/log" }
    let (:default_log_dir) { "~/.speedtest/log" }
    let (:custom_cron_dir) { "#{base_dir}/cron" }
    let (:default_cron_dir) { "~/.config/speedtest/cron" }
    let (:custom_cron_file) { "#{custom_cron_dir}/cron.rb" }
    let (:default_cron_file) { "#{default_cron_dir}/cron.rb" }
    let (:dirs) { [default_output_dir,
                   custom_output_dir,
                   default_log_dir,
                   custom_log_dir,
                   default_cron_dir,
                   custom_cron_dir] }
    let (:frequency_1hr) { ':hour' }
    let (:custom_cron_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

set :output, "#{default_log_dir}/cron.log"

every #{frequency_1hr} do
  command 'ruby speedtest_check'
end
FILE
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    describe 'create directories at locations other than /tmp/speedtest' do
      it 'creates output directory at /tmp/output but all other directories are at default locations' do
        system("speedtest_init --custom-output #{custom_output_dir}")
        expect(File.directory?(custom_output_dir)).to be true
        expect(File.directory?(default_log_dir)).to be true
        expect(File.directory?(default_cron_dir)).to be true        
      end

      it 'creates log directory at /tmp/log but all other directories are at default locations' do
        system("speedtest_init --custom-log #{custom_log_dir}")
        expect(File.directory?(custom_log_dir)).to be true
        expect(File.directory?(default_output_dir)).to be true
        expect(File.directory?(default_cron_dir)).to be true
      end

      it 'creates cron directory at /tmp/cron but all other directories are at default locations' do
        system("speedtest_init --custom-cron #{custom_cron_dir}")
        expect(File.directory?(custom_cron_dir)).to be true
        expect(File.directory?(default_output_dir)).to be true
        expect(File.directory?(default_log_dir)).to be true
      end
    end

    describe 'sets desired frequency, whilst creating all directories at default locations' do
      it 'overrides default "15.minutes" to every hour (:hour)' do
        system("speedtest_init --custom-frequency #{frequency_1hr}")
        expect(File.read(default_cron_file)).to eq(custom_cron_file_contents)
        expect(File.directory?(default_output_dir)).to be true
        expect(File.directory?(default_log_dir)).to be true
        expect(File.directory?(default_cron_dir)).to be true
      end
    end
  end

  describe 'supplying CLI flag --setup-default=true,' do
    let (:base_dir) { '/tmp' }
    let (:default_output_dir) { "~/.local/share/speedtest/output" }
    let (:default_log_dir) { "~/.speedtest/log" }
    let (:default_cron_dir) { "~/.config/speedtest/cron" }
    let (:default_cron_file) { "#{default_cron_dir}/cron.rb" }
    let (:dirs) { [default_output_dir,
                   default_log_dir,
                   default_cron_dir] }
    let (:frequency_1hr) { ':hour' }
    let (:default_frequency) { '15.minutes' }
    let (:default_cron_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

set :output, "#{default_log_dir}/cron.log"

every #{default_frequency} do
  command 'ruby speedtest_check'
end
FILE
    end
    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates all speedtest directories using default locations' do
      system('speedtest_init --setup-default true')
      dirs.each do |dir|
        expect(File.directory?(dir)).to be true
      end
    end

    it 'creates cron.rb schedule file' do
      system('speedtest_init --setup-default true')
      expect(File.exist?(default_cron_file)).to be true
    end

    it 'creates cron.rb schedule file with default contents' do
      system('speedtest_init --setup-default true')
      expect(File.read(default_cron_file)).to eq(default_cron_file_contents)
    end
  end

  describe 'if speedtest directories already exists,' do
    describe 'print warning messages,' do
      let (:output_dir) { "~/.local/share/speedtest/output" }
      let (:log_dir) { "~/.speedtest/log" }
      let (:cron_dir) { "~/.config/speedtest/cron" }
      let (:dirs) { [output_dir, log_dir, cron_dir] }
      let (:create_existing_directories) { dirs.each { |dir| FileUtils.mkdir_p(dir) } }

      before do
        create_existing_directories
      end

      after do
        # clean up
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
      end

      it 'does not recreate existing directories' do
        expect { system("speedtest_init --setup-default true") }
          .to output(include("#{cron_dir} exists, not created\n",
                             "#{log_dir} exists, not created\n",
                             "#{output_dir} exists, not created\n"))
          .to_stderr_from_any_process
      end
    end
  end
end
