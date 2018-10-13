require 'optparse'
require 'fileutils'

module SpeedTest
  class CLI
    def self.parse(options)
      @custom = {}
      opt_parser = OptionParser.new do |opt|
        opt.banner = 'Usage: speedtest_init [options]'

        opt.on('-h', '--help', 'Display this screen') do
          puts opt
          exit
        end

        opt.on('-o', '--output PATH', String, 'specify path for output directory') do |path|
          @custom[:output] = path
        end

        opt.on('-l', '--log PATH', String, 'specify path for log directory') do |path|
          @custom[:log] = path
        end

        opt.on('-c', '--cron PATH', String, 'specify path for cron directory') do |path|
          @custom[:cron] = path
        end

        opt.on('-f', '--frequency TIME', String, 'specify logging frequency') do |time|
          @custom[:frequency] = time
        end
      end
      opt_parser.parse!(options)
      @custom[:base_dir] = ARGV[0] || Dir.pwd # If it exists, ARGV remains is user's chosen setup path
      @custom
    end
  end
end
