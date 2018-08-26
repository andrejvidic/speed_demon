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
    let(:info) { 'speed info '}

    before do
      allow_any_instance_of(described_class).to receive(:system).with('speedtest-cli --simple').and_return(info)
    end

    it 'calls command line speedtest-cli' do
      expect(speed.info).to eq(info)
    end
  end
end
