require "optparse"

require_relative "covert_channel/server"
require_relative "covert_channel/constants"

PROGNAME = File.basename(__FILE__)

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = "usage: ruby #{PROGNAME} --capture_ip <capture_ip> --capture_port <capture_port>"

  opts.on("-i", "--capture_ip ip", "specify capture ip") do |ip|
    options[:capture_ip] = ip
  end

  opts.on("-p", "--capture_port port", "specify capture port") do |port|
    options[:capture_port] = port
  end

  opts.on("-h", "--help", "print help") do
    $stdout.puts opts
    exit(0)
  end
end

begin
  option_parser.parse!
rescue OptionParser::InvalidOption => e
  $stderr.puts option_parser.banner
  exit(1)
end

CovertChannel::Server.new(**options).call
