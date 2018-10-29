module SpeedTest
  class Settings
    attr_reader :output, :log, :frequency
    def initialize(args)
      @settings_file = File.expand_path(args[:settings_file] || "~/.config/speedtest")
      @output = args[:output]
      @log = args[:log]
      @frequency = args[:frequency]
    end

    def create_settings_file
      File.open(settings_file_name, "w") do |file|
        file.write(settings_file_contents).to_yaml
        file.close
      end
    end

    private

    def settings_file_name
      File.expand_path("#{@settings_file}/settings.yaml")
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
