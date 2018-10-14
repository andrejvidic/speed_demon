require 'optparse'
require 'fileutils'

module SpeedTest
  class CLI
    def self.parse(args)
      @options = ScriptOptions.new
      OptionParser.new do |parser|
        @options.define_options(parser)
        parser.parse!(args)
      end
      @options
    end

    class ScriptOptions
      attr_accessor :default, :output, :log, :cron, :frequency, :setup_options

      def initialize
        self.setup_options = false
      end

      def define_options(parser)
        parser.banner = 'Usage: speedtest_init [options]'

        display_help(parser)

        # CLI parse options
        setup_default(parser)
        custom_output_path(parser)
        custom_log_path(parser)
        custom_cron_path(parser)
        custom_frequency(parser)
      end

      def display_help(parser)
        parser.on('-h', '--help', 'Display this screen') do
          puts parser
          exit
        end
      end

      def setup_default(parser)
        parser.on('-s', '--setup-default', TrueClass, 'specify true/false, yes/no to setup speedtest to default directories') do |boolean|
          self.default = boolean
          self.setup_options = true
        end
      end

      def custom_output_path(parser)
        parser.on('-o', '--custom-output PATH', String, 'specify custom path for output directory') do |path|
          self.output = path
          self.setup_options = true          
        end
      end

      def custom_log_path(parser)
        parser.on('-l', '--custom-log PATH', String, 'specify custom path for log directory') do |path|
          self.log = path
          self.setup_options = true          
        end
      end

      def custom_cron_path(parser)
        parser.on('-c', '--custom-cron PATH', String, 'specify custom path for cron directory') do |path|
          self.cron = path
          self.setup_options = true          
        end
      end

      def custom_frequency(parser)
        parser.on('-f', '--custom-frequency TIME', String, 'specify custom speedtest measuring frequency') do |time|
          self.frequency = time
          self.setup_options = true
        end
      end
    end
  end
end
