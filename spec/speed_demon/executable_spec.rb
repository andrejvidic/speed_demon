require 'spec_helper'
require 'fileutils'

describe 'Run command line executable speed_demon,' do
  context 'with no options,' do
    it 'prints the help menu to STDOUT' do
      expect { system('speed_demon') }
        .to output(
          include('Usage: speed_demon [options]',
                  '-h, --help                       Display this screen',
                  '-m, --measure-speed              Measure internet speed and save it',
                  '-s, --setup-default              Setup speedtest directories using defaults',
                  '-o, --custom-output PATH         Override the default output directory with a custom',
                  '-l, --custom-log PATH            Override the default log directory with a custom',
                  '-f, --custom-frequency TIME      Override the default measuring frequency with a custom')
        ).to_stdout_from_any_process
    end
  end
end

describe 'Use custom command line options to,' do
  context 'override default output & log directories' do
    let(:output_dir) { File.expand_path("/tmp/speed_demon") }
    let(:log_dir) { File.expand_path("/tmp/log") }
    let(:config_dir) { File.expand_path("/tmp/custom/config") }
    let(:dirs) { [output_dir, log_dir, config_dir] }

    after do
      # cleanup
      dirs.each { |dir| FileUtils.rm_rf(dir) if File.directory?(dir) }
    end

    it 'outputs creation of custom directories /tmp/speed_demon & /tmp/log to STDOUT' do
      expect { system("speed_demon --custom-output #{output_dir} --custom-log #{log_dir}") }
        .to output(include("[add] `#{output_dir}'",
                           "[add] `#{log_dir}'")).to_stdout_from_any_process
    end
  end
end
