require 'spec_helper'

RSpec.describe SpeedTest::Settings do
  describe 'Setup has been completed and saved settings to yaml file,' do
    describe 'Settings.new is called' do
      let (:settings_file) { "/tmp/settings.yaml" }
      let (:output) { "/tmp/output" }
      let (:log) { "/tmp/log" }
      let (:frequency) { "2.minutes" }
      let (:settings_file_contents) do
<<FILE
---
output: #{output}
log: #{log}
frequency: #{frequency}
FILE
      end
      let (:settings) { described_class.new(settings_file: settings_file,
                                            output: output,
                                            log: log,
                                            frequency: frequency) }
      it 'exposes output path via settings.output' do
        expect(settings.output).to eq(output)
      end

      it 'exposes output path via settings.log' do
        expect(settings.log).to eq(log)
      end

      it 'exposes output path via settings.frequency' do
        expect(settings.frequency).to eq(frequency)
      end
    end
  end
end
