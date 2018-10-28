require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speedtest_init,' do
  describe 'with no flags or options,' do
    it 'prints the help menu to STDOUT' do
      expect { system('speedtest_init') }
        .to output(
          include("Usage: speedtest_init [options]",
                  "-h, --help                       Display this screen",
                  "-m, --measure-speed              Measure internet speed and save it",
                  "-s, --setup-default              Setup speedtest directories using defaults",
                  "-o, --custom-output PATH         Override the default output directory with a custom",
                  "-l, --custom-log PATH            Override the default log directory with a custom",
                  "-f, --custom-frequency TIME      Override the default measuring frequency with a custom")
        ).to_stdout_from_any_process
    end
  end
end

describe 'Run command line executable speedtest_init,' do
  describe 'supplying at least one custom option,' do
    let (:base_dir) { File.expand_path('/tmp') }
    let (:custom_output_dir) { File.expand_path("#{base_dir}/output") }
    let (:default_output_dir) { File.expand_path("~/.local/share/speedtest") }
    let (:custom_log_dir) { File.expand_path("#{base_dir}/log") }
    let (:default_log_dir) { File.expand_path("~/.speedtest") }
    let (:default_log_file) { File.expand_path("#{default_log_dir}/cron.log") }
    let (:default_config_dir) { File.expand_path("~/.config/speedtest") }
    let (:default_cron_file) { File.expand_path("#{default_config_dir}/cron.rb") }
    let (:dirs) { [default_output_dir,
                   custom_output_dir,
                   default_log_dir,
                   custom_log_dir,
                   default_config_dir] }
    let (:frequency_1hr) { ':hour' }
    let (:timestamp_generator_file) { File.expand_path("#{default_config_dir}/timestamp_generator.sh") }
    let (:path) {`echo $PATH`}
    let (:custom_cron_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

job_type :call_executable, 'export PATH=#{path} && :task'

every #{frequency_1hr} do
call_executable 'speedtest_init -m 2>&1 | #{timestamp_generator_file} >> #{default_log_file}'
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
        expect(File.directory?(default_config_dir)).to be true
      end

      it 'creates log directory at /tmp/log but all other directories are at default locations' do
        system("speedtest_init --custom-log #{custom_log_dir}")
        expect(File.directory?(custom_log_dir)).to be true
        expect(File.directory?(default_output_dir)).to be true
        expect(File.directory?(default_config_dir)).to be true
      end
    end

    describe 'sets desired frequency, whilst creating all directories at default locations' do
      it 'overrides default "15.minutes" to every hour (:hour)' do
        system("speedtest_init --custom-frequency #{frequency_1hr}")
        expect(File.read(default_cron_file)).to eq(custom_cron_file_contents)
        expect(File.directory?(default_output_dir)).to be true
        expect(File.directory?(default_log_dir)).to be true
        expect(File.directory?(default_config_dir)).to be true
      end
    end
  end
end

describe 'Run command line executable speedtest_init,' do
  describe 'supplying CLI flag --setup-default,' do
    let (:base_dir) { File.expand_path('/tmp') }
    let (:default_output_dir) { File.expand_path("~/.local/share/speedtest") }
    let (:default_log_dir) { File.expand_path("~/.speedtest") }
    let (:default_log_file) { File.expand_path("#{default_log_dir}/cron.log") }
    let (:default_config_dir) { File.expand_path("~/.config/speedtest") }
    let (:default_cron_file) { File.expand_path("#{default_config_dir}/cron.rb") }
    let (:default_settings_file) { File.expand_path("#{default_config_dir}/settings.yaml") }
    let (:dirs) { [default_output_dir,
                   default_log_dir,
                   default_config_dir] }
    let (:frequency_1hr) { ':hour' }
    let (:default_frequency) { '15.minutes' }
    let (:timestamp_generator_file) { File.expand_path("#{default_config_dir}/timestamp_generator.sh") }
    let (:path) {`echo $PATH`}
    let (:default_cron_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

job_type :call_executable, 'export PATH=#{path} && :task'

every #{default_frequency} do
call_executable 'speedtest_init -m 2>&1 | #{timestamp_generator_file} >> #{default_log_file}'
end
FILE
    end

    let (:default_settings_file_contents) do
<<FILE
---
output: #{default_output_dir}
log: #{default_log_dir}
frequency: #{default_frequency}
FILE
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates all speedtest directories using default locations' do
      system('speedtest_init --setup-default')
      dirs.each do |dir|
        expect(File.directory?(dir)).to be true
      end
    end

    it 'creates a config file called settings.yaml' do
      system('speedtest_init --setup-default')
      expect(File.exist?(default_settings_file)).to be true
    end

    it 'creates settings.yaml with default contents' do
      system('speedtest_init --setup-default')
      expect(File.read(default_settings_file)).to eq(default_settings_file_contents)
    end

    it 'creates cron.rb schedule file' do
      system('speedtest_init --setup-default')
      expect(File.exist?(default_cron_file)).to be true
    end

    it 'creates cron.rb schedule file with default contents' do
      system('speedtest_init --setup-default')
      expect(File.read(default_cron_file)).to eq(default_cron_file_contents)
    end
  end

  describe 'if speedtest directories already exists,' do
    describe 'print warning messages,' do
    let (:default_output_dir) { File.expand_path("~/.local/share/speedtest") }
    let (:default_log_dir) { File.expand_path("~/.speedtest") }
    let (:default_config_dir) { File.expand_path("~/.config/speedtest") }
    let (:dirs) { [default_output_dir,
                   default_log_dir,
                   default_config_dir] }
      let (:create_existing_directories) { dirs.each { |dir| FileUtils.mkdir_p(dir) } }

      before do
        create_existing_directories
      end

      after do
        # clean up
        dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
      end

      it 'does not recreate existing directories' do
        expect { system("speedtest_init --setup-default") }
          .to output(include("#{default_config_dir} exists, not created\n",
                             "#{default_log_dir} exists, not created\n",
                             "#{default_output_dir} exists, not created\n"))
          .to_stderr_from_any_process
      end
    end
  end
end
