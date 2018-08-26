require 'spec_helper'

describe SpeedTest::ExtractData do
  describe 'upon initialization, 'do
    before do
      allow_any_instance_of(described_class).to receive(:speed_info).and_return(speed_info)
    end

    let(:speed_info) { 'speed info '}
    let(:speed) { described_class.new}

    it 'calls speed_info' do
      expect(speed).to eq(speed_info)
    end
  end
end
