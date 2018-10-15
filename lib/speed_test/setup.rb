require 'fileutils'

module SpeedTest
  class Setup
    def self.execute(cli)
      setup = new(cli)
      setup.directories
      setup.cron_create
    end

    def initialize(cli)
      @output = cli.output || "~/.local/share/speedtest/output"
      @log = cli.log || "~/.speedtest/log"
      @cron = cli.cron || "~/.config/speedtest/cron"
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

    def cron_create
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
      [] << @output << @log << @cron
    end

    def cron_file_name
      "#{@cron}/cron.rb"
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
  end
end
