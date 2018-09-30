require 'fileutils'

module SpeedTest
  class Setup
    def initialize(options)
      @base = options[:base_dir]
      @output = options[:custom][:output] || "#{@base}/output"
      @dirs = dirs
    end

    def directories
      @dirs.each do |dir|
        if Dir.exist?(dir)
          warn "#{dir} exists, not created"
        else
          puts "[add] `#{dir}'"
          FileUtils.mkdir_p(dir)
        end
      end
    end

    private
    def dirs
      [] << 'speedtest' << @output << 'speedtest/cron_logs'
    end
  end
end
