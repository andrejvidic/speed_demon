require 'fileutils'

module SpeedTest
  class Setup
    def initialize(options)
      @base = "#{options[:base_dir]}/speedtest"
      @output = options[:custom][:output] || "#{@base}/output"
      @log = options[:custom][:log] || "#{@base}/log"
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

    private

    def dirs
      [] << @base << @output << @log
    end
  end
end
