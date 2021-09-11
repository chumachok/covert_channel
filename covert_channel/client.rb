require "packetgen"
require_relative "connection"

module CovertChannel
  class Client

    def initialize(dst_ip:, dst_port:, conn_class: Connection)
      @conn_class = conn_class
      @conn = conn_class.new(dst_ip: dst_ip, dst_port: dst_port)
    end

    def call
      connect
    end

    private

    def connect
      @conn.send_packet(flags: @conn_class::SYN + @conn_class::ACK)
      @conn.state = @conn_class::STATE_INITIATED
    end

    def close
      @conn.send_packet(flags: @conn_class::FIN)
    end

    def send_message
      @conn.send_packet(flags: @conn_class::PSH, payload: "test")
    end
  end
end