module SpeedTest
  class Settings
    attr_reader :output, :log, :frequency

    def self.create(args)
      settings_path = File.expand_path(args[:settings_path] || "~/.config/speedtest")
      self.new(args[:output], args[:log], args[:frequency], settings_path)
      self.create_settings_file
    end

    def self.load(settings_path)
      load = YAML::load_file(File.expand_path("#{settings_path}/settings.yaml"))
      self.new(load["output"], load["log"], load["frequency"], '')
    end

    def initialize(output, log, frequency, settings_path='')
      @output = output
      @log = log
      @frequency = frequency
    end

    def create_settings_file
      File.open(settings_file_name, "w") do |file|
        file.write(settings_file_contents).to_yaml
        file.close
      end
    end

    private

    def settings_file_name
      File.expand_path("#{@settings_path}/settings.yaml")
    end

    def settings_file_contents
<<FILE
---
output: #{output}
log: #{log}
frequency: #{frequency}
FILE
    end
  end
end
