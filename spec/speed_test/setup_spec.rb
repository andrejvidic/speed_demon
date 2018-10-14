require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedTest::Setup do
  describe 'calling directories,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest"}
    let (:output_dir) { "#{speedtest}/output" }
    let (:log_dir) { "#{speedtest}/log" }
    let (:cron_dir) { "#{speedtest}/cron" }
    let (:dirs) { [speedtest, output_dir, log_dir, cron_dir] }
    let (:options) { { base_dir: base_dir, output: output_dir, log: log_dir } }
    before do
      Dir.chdir(base_dir) # set_current_directory
      SpeedTest::Setup.new(options).directories # create_directories
    end

    after do
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) } # cleanup
    end

    it 'creates output directory at /tmp/output' do
      expect(File.directory?(output_dir)).to be true
    end

    it 'creates log directory at /tmp/log' do
      expect(File.directory?(log_dir)).to be true
    end

    it 'creates the cron directory at /tmp/cron' do
      expect(File.directory?(cron_dir)).to be true
    end
  end

  describe 'calling cron methods,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest"}
    let (:cron_dir) { "#{speedtest}/cron"}
    let (:cron_file) { "#{cron_dir}/cron.rb"}
    let (:output_dir) { "#{base_dir}/output" }
    let (:log_dir) { "#{base_dir}/log" }
    let (:dirs) { [speedtest, output_dir, log_dir, cron_dir] }
    let (:options) { { base_dir: base_dir, output: output_dir, log: log_dir } }
    let (:whenever) { 'whenever gem called' }
    let (:setup) { SpeedTest::Setup.new(options) }
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
      setup.directories
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    describe 'cron_start' do
      it 'adds and starts the cron_task by calling the whenever gem' do
        allow_any_instance_of(SpeedTest::Setup).to receive(:system)
          .with("whenever --load-file #{cron_file}")
          .and_return(whenever)
        expect(setup.cron_start).to eq(whenever)
      end
    end

    describe 'cron_create' do
      it 'creates the cron file' do
        setup.cron_create
        expect(File.exist?(cron_file)).to be true
      end

      it 'has the correct default contents' do
        setup.cron_create
        expect(File.read(cron_file)).to eq(default_cron_file_contents)
      end

      describe 'after calling the whenever gem,' do
        it 'creates the cron directory' do
          setup.cron_create
          expect(File.directory?(cron_dir)).to be true
        end
      end
    end
  end
end
