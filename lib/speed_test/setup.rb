require 'fileutils'

module SpeedTest
  class Setup
    def initialize(options)
      @dirs = ['speedtest', 'speedtest/output', 'speedtest/cron_logs']
      @base = options[:base_dir]
    end

    def create_directories
      @dirs.each do |dir|
        path = File.join(@base, dir)

        if Dir.exist?(path)
          warn "#{dir} exists, not created"
        else
          puts "[add] `#{path}'"
          FileUtils.mkdir_p(path)
        end
      end
    end
  end
end
