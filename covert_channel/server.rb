require "packetgen"
require_relative "connection"

module CovertChannel
  class Server
    OUTPUT_FILE_PATH = "data/out.txt"

    def initialize(listen_port:, listen_ip: nil, conn_class: Connection)
      @listen_ip = listen_ip
      @listen_port = listen_port
      @conn_class = conn_class
    end

    def call
      capture_filter = ""
      capture_filter << "ip src #{@listen_ip} " if @listen_ip
      capture_filter << "dst port #{@listen_port}"
      PacketGen.capture(filter: capture_filter) do |packet|
        handle(packet)
      end
    end

    private

    def handle(packet)
      tcph = packet.tcp
      iph = packet.ip
      conn = @conn_class.new(dst_ip: iph.src, dst_port: tcph.sport)
      if tcph.flag_syn?
        conn.send_packet(flags: @conn_class::SYN + @conn_class::ACK, seqnum: rand(0..(2**32 - 1)), acknum: tcph.seqnum + 1)
      elsif tcph.flag_rst?

      elsif tcph.flag_psh?

      elsif tcph.flag_fin?

      elsif tcph.flag_ack?

      end
    end
  end
end