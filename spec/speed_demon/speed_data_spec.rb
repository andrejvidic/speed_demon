require 'spec_helper'

describe SpeedDemon::SpeedData do
  describe 'upon initialization,' do
    before do
      allow_any_instance_of(described_class).to receive(:info).and_return(info)
    end

    let(:info) { 'speed info ' }
    let(:speed) { described_class.new }

    it 'calls info' do
      expect(speed.info).to eq(info)
    end
  end

  describe 'during initialization' do
    let(:speed_data) { described_class.new }
    let(:info) { "Ping: 5.036 ms\nDownload: 36.31 Mbit/s\nUpload: 5.43 Mbit/s" }
    let(:info_array) do
      ['Ping: 5.036 ms',
       'Download: 36.31 Mbit/s',
       'Upload: 5.43 Mbit/s']
    end
    let(:ping) { '5.036' }
    let(:download) { '36.31' }
    let(:upload) { '5.43' }
    let(:ping_unit) { 'ms' }
    let(:download_unit) { 'Mbit/s' }
    let(:upload_unit) { 'Mbit/s' }
    let(:time) { Time.now }

    before do
      allow(Open3).to receive(:capture3).with('speedtest-cli --simple').and_return(info)
    end

    it 'calls command line speedtest-cli' do
      expect(Open3).to receive(:capture3).with('speedtest-cli --simple').and_return(info)
      speed_data
    end

    it 'extracts the ping value' do
      expect(speed_data.ping).to eq(ping)
    end

    it 'extracts the download value' do
      expect(speed_data.download).to eq(download)
    end

    it 'extracts the upload value' do
      expect(speed_data.upload).to eq(upload)
    end

    it 'extracts the ping unit' do
      expect(speed_data.ping_unit).to eq(ping_unit)
    end

    it 'extracts the download unit' do
      expect(speed_data.download_unit).to eq(download_unit)
    end

    it 'extracts the upload unit' do
      expect(speed_data.upload_unit).to eq(upload_unit)
    end

    it 'extracts the time' do
      allow(Time).to receive(:now).and_return(time)
      expect(speed_data.time).to eq(time)
    end
  end
end
