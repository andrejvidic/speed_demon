require 'spec_helper'

describe SpeedTest::SpeedData do
  describe 'upon initialization, 'do
    before do
      allow_any_instance_of(described_class).to receive(:info).and_return(info)
    end

    let(:info) { 'speed info '}
    let(:speed) { described_class.new}

    it 'calls info' do
      expect(speed.info).to eq(info)
    end
  end

  describe 'during initialization' do
    let(:speed) { described_class.new }
    let(:info) { 'Ping: 5.036ms\nDownload: 36.31 Mbit/s\nUpload: 5.43 Mbit/s'}
    let(:info_array) { ['Ping: 5.036ms', 'Download: 36.31 Mbit/s', 'Upload: 5.43 Mbit/s'] }

    before do
      allow_any_instance_of(described_class).to receive(:system).with('speedtest-cli --simple').and_return(info)
    end

    it 'calls command line speedtest-cli' do
      expect(speed.info).to eq(info_array)
    end
  end
end
