require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedDemon::Setup do
  describe 'calling execute with default options,' do
    let (:output_dir) { File.expand_path("~/.local/share/speed_demon") }
    let (:log_dir) { File.expand_path("~/.speed_demon") }
    let (:config_dir) { File.expand_path("~/.config/speed_demon") }
    let (:cron_schedule_file) { File.expand_path("#{config_dir}/cron.rb") }
    let (:cron_log_file) { File.expand_path("#{log_dir}/cron.log") }
    let (:dirs) { [output_dir, log_dir, config_dir] }
    let (:timestamp_generator_file) { File.expand_path("#{config_dir}/timestamp_generator.sh") }
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
call_executable 'speed_demon -m 2>&1 | #{timestamp_generator_file} >> #{cron_log_file}'
end
FILE
    end

    let (:timestamp_generator_file_contents) do
<<FILE
#!/bin/bash

while read x; do
    echo -n `date '+%Y-%m-%dT%T%z'`;
    echo -n " ";
    echo $x;
done
FILE
    end

    let (:cron_log_file_contents) do
<<FILE
2018-10-28T17:05:15+1100 sh: 1: executable_that_doesnt_exist: not found
FILE
    end
    let (:config_dir) { File.expand_path("~/.config/speed_demon") }

    before do
      allow_any_instance_of(described_class).to receive(:system)
        .with("whenever --update-crontab --load-file  #{cron_schedule_file}")
        .and_return(whenever)
      described_class.execute(cli, config_dir)
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates the default output directory' do
      expect(File.directory?(output_dir)).to be true
    end

    it 'creates the default custom log directory' do
      expect(File.directory?(log_dir)).to be true
    end

    it 'creates the default config directory' do
      expect(File.directory?(config_dir)).to be true
    end

    it 'adds and starts_log_task by  calling the whenever gem' do
      expect(described_class.new(cli, config_dir).cron_start).to eq(whenever)
    end

    it 'creates the cron schedule file with correct defaults' do
      expect(File.exist?(cron_schedule_file)).to be true
      expect(File.read(cron_schedule_file)).to eq(cron_schedule_file_contents)
    end

    it 'creates the add_timestamp executable' do
      expect(File.exist?(timestamp_generator_file)).to be true
      expect(File.read(timestamp_generator_file)).to eq(timestamp_generator_file_contents)
    end

    it 'logs an error with timestamp to default cron.log file' do
      `executable_that_doesnt_exist 2>&1 | "#{timestamp_generator_file}" >> "#{cron_log_file}"`
      cron_log_file_contents_array = File.read(cron_log_file).partition(' ')
      cron_log_file_time = cron_log_file_contents_array.first
      cron_log_file_error = cron_log_file_contents_array.last
      expect{ DateTime.strptime(cron_log_file_time, '%Y-%m-%dT%T%z') }.to_not raise_error
      expect(cron_log_file_error).to eq("sh: 1: executable_that_doesnt_exist: not found\n")
    end
  end
end
