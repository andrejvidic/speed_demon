require 'spec_helper'

describe SpeedTest::ConnectionType do
  describe 'using ip link command from linux ip package, ' do
    let(:wireless_connection?) { SpeedTest::ConnectionType.wireless?}

    it 'makes a system call to ip link' do
      expect(wireless_connection?).to receive(:system).with('ip link')
      wireless_connection?
    end
  end
end
