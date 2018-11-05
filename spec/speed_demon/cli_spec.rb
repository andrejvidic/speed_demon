require 'spec_helper'

RSpec.describe SpeedDemon::CLI do
  it 'extracts output from --custom-output flag given on the command line' do
    cli = described_class.parse(['--custom-output', '/tmp/custom/output'])
    expect(cli.output).to eq('/tmp/custom/output')
    expect(cli.measure).to be false
  end

  it 'extracts log from --custom-log flag given on the command line' do
    cli = described_class.parse(['--custom-log', '/tmp/custom/log'])
    expect(cli.log).to eq('/tmp/custom/log')
    expect(cli.measure).to be false
  end

  it 'extracts frequency from --custom-frequency flag given on the command line' do
    cli = described_class.parse(['--custom-frequency', '2.minutes'])
    expect(cli.frequency).to eq('2.minutes')
    expect(cli.measure).to be false
  end

  it 'sets setup to true when --custom-output is given' do
    cli = described_class.parse(['--custom-output', '/tmp/custom/output'])
    expect(cli.setup).to be true
    expect(cli.measure).to be false
  end

  it 'sets setup to true when --custom-log is given' do
    cli = described_class.parse(['--custom-log', '/tmp/custom/log'])
    expect(cli.setup).to be true
    expect(cli.measure).to be false
  end

  it 'sets setup to true when --custom-frequency is given' do
    cli = described_class.parse(['--custom-frequency', '2.minutes'])
    expect(cli.setup).to be true
    expect(cli.measure).to be false
  end

  it 'sets setup to true when --setup-default is given' do
    cli = described_class.parse(['--setup-default'])
    expect(cli.setup).to be true
    expect(cli.measure).to be false
  end

  it 'sets measure to true when --measure-speed is given' do
    cli = described_class.parse(['--measure-speed'])
    expect(cli.setup).to be false
    expect(cli.measure).to be true
  end
end
