require "packetgen"
require_relative "connection"

module CovertChannel
  class Server
    OUTPUT_FILE_PATH = "data/out.txt"

    def initialize(listen_port:, listen_ip: nil)
      @listen_ip = listen_ip
      @listen_port = listen_port
    end

    def call
      capture_filter = ""
      capture_filter << "ip src #{@listen_ip} " if @listen_ip
      capture_filter << "dst port #{@listen_port}"
      # filter: 'ip src 127.0.0.1'
      PacketGen.capture(iface: "wlo1", filter: capture_filter) do |packet|
        handle(packet)
      end
    end

    private

    def handle(packet)
      tcph = packet.headers.find { |header| header.is_a?(PacketGen::Header::TCP) }
      if tcph.flag_syn?
        
      elsif tcph.flag_rst?

      elsif tcph.flag_psh?

      elsif tcph.flag_fin?

      elsif tcph.flag_ack?

      end
    end

    # def call
      # capture_filter = ""
      # capture_filter << "ip src #{@listen_ip} " if @listen_ip
      # capture_filter << "dst port #{@listen_port}"
      # PacketGen.capture(iface: "wlo1", filter: 'ip src 127.0.0.1') do |packet|
      #   p packet
        # ip_header = packet.headers.find { |h| h.is_a?(PacketGen::Header::IP) }&.to_h
        # # get the encoded value
        # File.open(OUTPUT_FILE_PATH, "a") do |f|
          
        #   f << 
        # end
      # end
    # end
  end
end