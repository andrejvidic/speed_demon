require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedTest::Setup do
  describe 'calling directories,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest"}
    let (:config) { "#{speedtest}/config"}
    let (:schedule_file) { "#{speedtest}/config/schedule.rb"}
    let (:output_dir) { "#{base_dir}/output" }
    let (:cron_log_dir) { "#{base_dir}/log" }
    let (:dirs) { [speedtest, output_dir, cron_log_dir] }
    let (:options) { { base_dir: base_dir, custom: { output: output_dir, log: cron_log_dir } } }
    let (:whenever) { 'whenever gem called' }
    let (:setup) { SpeedTest::Setup.new(options) }

    before do
      setup.directories
    end

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'calls the whenever gem' do
      allow_any_instance_of(SpeedTest::Setup).to receive(:system)
        .with("wheneverize #{speedtest}")
        .and_return(whenever)
      expect(setup.create_cron).to eq(whenever)
    end

    describe 'calls whenever gem,' do
      it 'creates the config directory' do
        setup.create_cron
        expect(File.directory?(config)).to be true
      end

      it 'creates the tasks directory' do
        setup.create_cron
        expect(File.exist?(schedule_file)).to be true
      end
    end
  end
end
