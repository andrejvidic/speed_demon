require 'spec_helper'

describe SpeedTest::SpeedData do
  describe 'upon initialization, 'do
    before do
      allow_any_instance_of(described_class).to receive(:speed_info).and_return(speed_info)
    end

    let(:speed_info) { 'speed info '}
    let(:speed) { described_class.new}

    it 'calls speed_info' do
      expect(speed.speed_info).to eq(speed_info)
    end
  end

  describe 'during initialization' do
    let(:speed) { described_class.new }
    let(:speed_info) { 'speed info '}

    before do
      allow_any_instance_of(described_class).to receive(:system).with('speedtest-cli --simple').and_return(speed_info)
    end

    it 'calls command line speedtest-cli' do
      expect(speed.speed_info).to eq(speed_info)
    end
  end
end
