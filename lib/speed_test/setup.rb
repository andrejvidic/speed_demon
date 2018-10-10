require 'fileutils'

module SpeedTest
  class Setup
    def initialize(options)
      @base = "#{options[:base_dir]}/speedtest"
      @output = options[:custom][:output] || "#{@base}/output"
      @log = options[:custom][:log] || "#{@base}/log"
      @schedule = options[:custom][:schedule] || "#{@base}/schedule"
      @frequency = options[:custom][:frequency] || '15.minutes'
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
      File.open(schedule_file_name, "w") do |file|
        file.write(schedule_file_contents)
        file.close
      end
    end

    def cron_start
      system("whenever --load-file #{schedule_file_name}")
    end

    private

    def dirs
      [] << @base << @output << @log << @schedule
    end

    def schedule_file_name
      "#{@schedule}/schedule.rb"
    end

    def schedule_file_contents
<<FILE
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#

set :output, "#{@log}/cron.log"

every #{@frequency} do
  command 'ruby speed_test_check'
end
FILE
    end
  end
end
