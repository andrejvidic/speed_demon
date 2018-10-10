require 'fileutils'

module SpeedTest
  class Setup
    def initialize(options)
      @base = "#{options[:base_dir]}/speedtest"
      @output = options[:custom][:output] || "#{@base}/output"
      @log = options[:custom][:log] || "#{@base}/log"
      @schedule = options[:custom][:schedule] || "#{@base}/schedule"
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

    def create_cron
      system("wheneverize #{@base}")
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
