require 'spec_helper'

describe SpeedDemon::ConnectionType do
  describe 'upon intialization, ' do
    before do
    allow_any_instance_of(described_class).to receive(:connection_info).and_return(ip_link)
    end

    let(:connection) { described_class.new }
    let(:ip_link) { 'connection_info_string' }

    it 'calls method connection_info' do
      expect(connection.connection_info).to eq(ip_link)
    end
  end

  describe 'during intialization, ' do
    let(:connection) { described_class.new }
    let(:ip_link) { 'connection_info_string' }

    before do
      allow(Open3).to receive(:capture3).with('ip link').and_return(ip_link)
    end

    it 'calls linux ip link' do
      expect(connection.connection_info).to eq(ip_link)
    end
  end

  describe '#wireless?' do
    let(:ip_link) { '1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp58s0f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
    link/ether 80:fa:5b:46:a2:9f brd ff:ff:ff:ff:ff:ff
3: wlp59s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT group default qlen 1000
    link/ether 00:28:f8:aa:b4:64 brd ff:ff:ff:ff:ff:ff' }
    let(:connection) { described_class.new }

    before do
      allow(Open3).to receive(:capture3).with('ip link').and_return(ip_link)
    end

    it 'returns true when connection is wireless' do
      expect(connection.wireless?).to be(true)
    end
  end

  describe '#wireless?' do
    let(:ip_link) { '1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp58s0f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 80:fa:5b:46:a2:9f brd ff:ff:ff:ff:ff:ff
3: wlp59s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state DOWN mode DORMANT group default qlen 1000
    link/ether 00:28:f8:aa:b4:64 brd ff:ff:ff:ff:ff:ff' }
    let(:connection) { described_class.new }

    before do
      allow(Open3).to receive(:capture3).with('ip link').and_return(ip_link)
    end

    it 'returns false when connection is network' do
      expect(connection.wireless?).to be(false)
    end
  end
end
