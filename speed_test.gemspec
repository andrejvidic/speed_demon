# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speed_test/version'

Gem::Specification.new do |spec|
  spec.name          = "speed_test"
  spec.version       = SpeedTest::VERSION
  spec.authors       = ["Andre Vidic"]
  spec.email         = ["andrevidic1@gmail.com"]

  spec.summary       = %q{Schedule internet speed test checks and easily log the data}
  spec.description   = %q{Wrapping the awesome whenever gem to add cron scheduling functionality as well as wrapping speedtest-cli to run easily run an internet speed test against your closest isp}
  spec.homepage      = "https://github.com/drej2k/speed_test"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 9.0.6"
end
