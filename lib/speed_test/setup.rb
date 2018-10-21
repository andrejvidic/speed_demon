require 'fileutils'
require 'yaml'

module SpeedTest
  class Setup
    def self.execute(cli)
      setup = new(cli)
      setup.directories
      setup.settings
      setup.cron
    end

    def initialize(cli)
      @output = File.expand_path(cli.output || "~/.local/share/speedtest/output")
      @log = File.expand_path(cli.log || "~/.speedtest/log")
      @config = File.expand_path(cli.config || "~/.config/speedtest")
      @frequency = cli.frequency || '15.minutes'
    end

    def directories
      dirs.each do |dir|
        if Dir.exist?(dir)
          warn "#{dir} exists, not created"
        else
          puts "[add] `#{dir}'"
          FileUtils.mkdir_p(dir)
        end
      end
    end

    def settings
      File.open(settings_file_name, "w") do |file|
        file.write(settings_file_contents).to_yaml
        file.close
      end
    end

    def cron
      File.open(cron_file_name, "w") do |file|
        file.write(cron_file_contents)
        file.close
      end
    end    

    def cron_start
      system("whenever --load-file #{cron_file_name}")
    end

    private

    def dirs
      [] << @output << @log << @config
    end

    def cron_file_name
      File.expand_path("#{@config}/cron.rb")
    end

    def cron_file_contents
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

set :output, "#{@log}/cron.log"

every #{@frequency} do
  command 'ruby speedtest_check'
end
FILE
    end

    def settings_file_name
      File.expand_path("#{@config}/settings.yml")
    end

    def settings_file_contents
      { output: @output,
        log: @log,
        config: @config }
    end
  end
end
