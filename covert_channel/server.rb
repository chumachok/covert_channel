require "packetgen"
require_relative "constants"

module CovertChannel
  class Server
    OUTPUT_FILE_PATH = File.join(__dir__, "..", "out", "out.txt")

    def initialize(capture_ip: nil, capture_port: DNS_PORT)
      @capture_ip = capture_ip
      @capture_port = capture_port
    end

    def call
      reset_output_file(OUTPUT_FILE_PATH)

      capture_filter = ""
      capture_filter << "ip src #{@capture_ip} &&" if @capture_ip
      capture_filter << "dst port #{@capture_port}"

      PacketGen.capture(iface: "wlo1", filter: capture_filter) do |packet|
        ttl = packet&.ip&.ttl
        if ttl < DEFAULT_MIN_TTL
          file_content = File.read(OUTPUT_FILE_PATH)
          puts "------------------------- message captured -------------------------\n#{file_content}\nexiting..."
          exit(0)
        end
        char = decode(ttl)
        File.open(OUTPUT_FILE_PATH, "a") { |f| f << char }
      end
    end

    private

    def decode(ttl)
      (ttl - DEFAULT_MIN_TTL).chr
    end

    def reset_output_file(path)
      File.write(path, "")
    end

  end
end