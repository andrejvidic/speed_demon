require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedTest::Setup do
  describe 'calling execute with default options,' do
    let (:output_dir) { File.expand_path("~/.local/share/speedtest") }
    let (:log_dir) { File.expand_path("~/.speedtest") }
    let (:config_dir) { File.expand_path("~/.config/speedtest") }
    let (:cron_schedule_file) { File.expand_path("#{config_dir}/cron.rb") }
    let (:cron_log_file) { File.expand_path("#{log_dir}/cron.log") }
    let (:dirs) { [output_dir, log_dir, config_dir] }
    let (:add_timestamp_file) { File.expand_path("#{config_dir}/add_timestamp.sh") }
    let (:path) {`echo $PATH`}
    class MockCli
      attr_reader :output, :log, :frequency
      def initialize
        @output = nil
        @log = nil
        @frequency = nil
      end
    end
    let (:cli) { MockCli.new }
    let (:whenever) { 'whenever gem called' }
    let (:default_frequency) { '15.minutes' }
    let (:cron_schedule_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

job_type :call_executable, 'export PATH=#{path} && :task'

every #{default_frequency} do
call_executable 'speedtest_init -m >> #{cron_log_file} 2>&1'
end
FILE
    end

    let (:add_timestamp_file_contents) do
<<FILE
#!/bin/bash

while read x; do
    echo -n `date '+%Y-%m-%dT%T%z'`;
    echo -n " ";
    echo $x;
done
FILE
    end

    before do
      allow_any_instance_of(described_class).to receive(:system)
        .with("whenever --update-crontab --load-file  #{cron_schedule_file}")
        .and_return(whenever)
      described_class.execute(cli)
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates the default output directory at ~/.local/share/speedtest/output' do
      expect(File.directory?(output_dir)).to be true
    end

    it 'creates the default custom log directory at ~/.speedtest/log' do
      expect(File.directory?(log_dir)).to be true
    end

    it 'creates the default config directory at ~/.config/speedtest/' do
      expect(File.directory?(config_dir)).to be true
    end

    it 'adds and starts_log_task by  calling the whenever gem' do
      expect(described_class.new(cli).cron_start).to eq(whenever)
    end

    it 'creates the cron schedule file with correct defaults' do
      expect(File.exist?(cron_schedule_file)).to be true
      expect(File.read(cron_schedule_file)).to eq(cron_schedule_file_contents)
    end

    it 'creates the add_timestamp executable' do
      expect(File.exist?(add_timestamp_file)).to be true
      expect(File.read(add_timestamp_file)).to eq(add_timestamp_file_contents)
    end
  end
end
