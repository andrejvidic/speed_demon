require 'spec_helper'

RSpec.describe SpeedTest::Settings do
  describe 'Save & load settings to/from yaml file,' do
    let (:output) { "/tmp/output" }
    let (:log) { "/tmp/log" }
    let (:frequency) { "2.minutes" }
    let (:config) { "/tmp/config" }
    let (:create_settings_yaml) do
      described_class.create(config: config,
                             output: output,
                             log: log,
                             frequency: frequency)
    end

    before do
      FileUtils.mkdir_p(config) # make directory as this is usually done in SpeedTest::Setup
      create_settings_yaml
    end

    after do
      FileUtils.rm_rf(config) if File.directory?(config) # cleanup
    end
    it 'loads output settings given correct path' do
      expect(described_class.load(config).output).to eq(output)
    end

    it 'loads log settings given correct path' do
      expect(described_class.load(config).log).to eq(log)
    end

    it 'loads frequency settings given correct path' do
      expect(described_class.load(config).frequency).to eq(frequency)
    end
  end
end
