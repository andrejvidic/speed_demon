require 'spec_helper'
require 'fileutils'

RSpec.describe SpeedTest::Setup do
  describe 'calling create_cron method,' do
    let (:base_dir) { '/tmp' }
    let (:speedtest) { "#{base_dir}/speedtest"}
    let (:config) { "#{speedtest}/config"}
    let (:schedule_file) { "#{speedtest}/config/schedule.rb"}
    let (:output_dir) { "#{base_dir}/output" }
    let (:cron_log_dir) { "#{base_dir}/log" }
    let (:create_speedtest_dir) { Dir.mkdir(speedtest) }
    let (:options) { {base_dir: base_dir, custom: { output: output_dir, log: cron_log_dir }} }
    let (:whenever) { 'whenever gem called' }

    before do
      create_speedtest_dir
    end

    after do
      # cleanup
      FileUtils.rm_rf(speedtest) if File.directory?(speedtest)
    end

    it 'calls the whenever gem' do
      allow_any_instance_of(SpeedTest::Setup).to receive(:system)
        .with("wheneverize #{speedtest}")
        .and_return(whenever)
      expect(SpeedTest::Setup.new(options).create_cron).to eq(whenever)
    end
  end
end
