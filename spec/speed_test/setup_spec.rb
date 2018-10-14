require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedTest::Setup do
  describe 'calling execute with default options,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest" }
    let (:output_dir) { "~/.local/share/speedtest/output" }
    let (:log_dir) { "~/.speedtest/log" }
    let (:cron_dir) { "~/.config/speedtest/cron" }
    let (:cron_file) { "#{cron_dir}/cron.rb" }
    let (:dirs) { [speedtest, output_dir, log_dir, cron_dir] }
    let (:options) { { base_dir: base_dir, output: output_dir, log: log_dir, cron: cron_dir } }
    let (:whenever) { 'whenever gem called' }
    let (:default_frequency) { '15.minutes' }
    let (:default_cron_file_contents) do
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

set :output, "#{log_dir}/cron.log"

every #{default_frequency} do
  command 'ruby speedtest_check'
end
FILE
    end

    before do
      Dir.chdir(base_dir) # set_current_directory
      SpeedTest::Setup.execute(options)
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'creates the default output directory at speedtest/output' do
      expect(File.directory?(output_dir)).to be true
    end

    it 'creates the default custom log directory at speedtest/log' do
      expect(File.directory?(log_dir)).to be true
    end

    it 'creates the default cron directory at speedtest/cron' do
      expect(File.directory?(cron_dir)).to be true
    end

    it 'adds and starts the cron_task by calling the whenever gem' do
      allow_any_instance_of(SpeedTest::Setup).to receive(:system)
        .with("whenever --load-file #{cron_file}")
        .and_return(whenever)
    end

    it 'creates the cron file with correct defaults' do
      expect(File.exist?(cron_file)).to be true
      expect(File.read(cron_file)).to eq(default_cron_file_contents)
    end
  end
end
