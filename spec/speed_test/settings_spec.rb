require 'spec_helper'

RSpec.describe SpeedTest::Settings do
  describe 'Setup has been completed and saved settings to yaml file,' do
    describe 'Settings.new is called' do
      let (:output) { "/tmp/output" }
      let (:log) { "/tmp/log" }
      let (:frequency) { "2.minutes" }
      let (:settings_path) { "/tmp" }
      let (:settings) { described_class.create(settings_path: settings_path,
                                               output: output,
                                               log: log,
                                               frequency: frequency) }
      it 'exposes output path via settings.load(settings_path).output' do
        expect(described_class.load(settings_path).output).to eq(output)
      end

      it 'exposes output path via settings.load(settings_path).log' do
        expect(described_class.load(settings_path).log).to eq(log)
      end

      it 'exposes output path via settings.load(settings_path).frequency' do
        expect(described_class.load(settings_path).frequency).to eq(frequency)
      end

      it 'loads output settings given correct path' do
        expect(described_class.load(settings_path).output).to eq(output)
      end

      it 'loads log settings given correct path' do
        expect(described_class.load(settings_path).log).to eq(log)
      end

      it 'loads frequency settings given correct path' do
        expect(described_class.load(settings_path).frequency).to eq(frequency)
      end
    end
  end
end
