require 'yaml'

module SpeedDemon
  # Create & load from persistent settings.yaml file
  class Settings
    attr_reader :output, :log, :config, :frequency

    def self.create(args)
      settings = new(args)
      settings.create_settings_file
    end

    def self.load(config_dir)
      settings_file = File.expand_path("#{config_dir}/settings.yaml")
      raise LoadError, 'settings.yaml does not exist. Run setup' unless File.exist?(settings_file)

      load = YAML.load_file(settings_file)
      new(output: load[:output], log: load[:log], frequency: load[:frequency], config: '')
    end

    def initialize(args)
      @output = args[:output]
      @log = args[:log]
      @frequency = args[:frequency]
      @config = args[:config]
    end

    def create_settings_file
      File.open(settings_file_name, 'w') do |file|
        file.write(settings_file_yaml)
        file.close
      end
    end

    private

    def settings_file_name
      File.expand_path("#{@config}/settings.yaml")
    end

    def settings_file_yaml
      Hash[output: @output,
           log: @log,
           frequency: @frequency ].to_yaml
    end
  end
end
