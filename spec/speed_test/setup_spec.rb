require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedTest::Setup do
  describe 'calling execute with default options,' do
    let (:default_output_dir) { "~/.local/share/speedtest/output" }
    let (:default_log_dir) { "~/.speedtest/log" }
    let (:default_cron_dir) { "~/.config/speedtest/cron" }
    let (:default_cron_file) { "#{default_cron_dir}/cron.rb" }
    let (:dirs) { [default_output_dir, default_log_dir, default_cron_dir] }
    class MockCli
      attr_reader :output, :log, :cron, :frequency
      def initialize
        @output = nil
        @log = nil
        @cron = nil
        @frequency = nil
      end
    end
    let (:cli) { MockCli.new }
    let (:whenever) { 'whenever gem called' }
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

    before do
      SpeedTest::Setup.execute(cli)
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates the default output directory at speedtest/output' do
      expect(File.directory?(default_output_dir)).to be true
    end

    it 'creates the default custom log directory at speedtest/log' do
      expect(File.directory?(default_log_dir)).to be true
    end

    it 'creates the default cron directory at speedtest/cron' do
      expect(File.directory?(default_cron_dir)).to be true
    end

    it 'adds and starts the cron_task by calling the whenever gem' do
      allow_any_instance_of(SpeedTest::Setup).to receive(:system)
        .with("whenever --load-file #{default_cron_file}")
        .and_return(whenever)
    end

    it 'creates the cron file with correct defaults' do
      expect(File.exist?(default_cron_file)).to be true
      expect(File.read(default_cron_file)).to eq(default_cron_file_contents)
    end
  end
end
