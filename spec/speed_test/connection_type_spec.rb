require 'spec_helper'

describe SpeedTest::ConnectionType do
  describe 'upon intialization, ' do
    before do
    allow_any_instance_of(SpeedTest::ConnectionType).to receive(:connection_info).and_return(ip_link)
    end

    let(:connection) { described_class.new }
    let(:ip_link) { 'connection_info_string' }

    it 'calls method connection_info' do
      expect(connection.connection_info).to eq(ip_link)
    end
  end
end
