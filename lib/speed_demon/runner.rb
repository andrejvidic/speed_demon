module SpeedDemon
  class Runner
    attr_reader :cli, :config_dir
    def initialize(argv)
      @cli = SpeedDemon::CLI.parse(argv)
      @config_dir = '~/.config/speed_demon'
    end

    def self.start(argv)
      run = new(argv)
      if run.cli.setup
        run.setup
      elsif run.cli.measure
        run.measure
      else
        run.display_cli_help
      end
    end

    def measure
      settings = SpeedDemon::Settings.load(@config_dir)
      measurements = SpeedDemon::SpeedData.new('speedtest-cli --simple')
      wireless = SpeedDemon::ConnectionType.new.wireless?
      SpeedDemon::SaveData.execute(output_path: settings.output, data: measurements, wireless: wireless)
    end

    def setup
      SpeedDemon::Setup.execute(output: @cli.output,
                                log: @cli.log,
                                config: @config_dir,
                                frequency: @cli.frequency)
    end

    def display_cli_help
      warn 'speed_demon CLI received no options!'
      system('speed_demon -h')
    end
  end
end
