
require "packetgen"
require_relative "connection"

module CovertChannel
  class Client
    SYN = 0x1002
    PSH = 0x1008

    def initialize(dst_ip:, dst_port:)
      @dst_ip = dst_ip
      @dst_port = dst_port
    end

    def call
      connect
    end

    private

    def connect
      send_packet(flags: SYN)
    end

    def send_message
      send_packet(flags: PSH, payload: "test")
    end

    # def send_syn
    #   pkt = PacketGen.gen("IP").add("TCP")
    #   pkt.ip(dst: @dst_ip)
    #   pkt.tcp(dport: @dst_port, sport: rand(49152..65535), flag_syn: 1, body: "test")
    #   # p pkt.headers.each { |h| p h.to_h rescue nil }
    #   pkt.to_w("wlo1")
    # end

    def send_packet(flags:, payload: "")
      pkt = PacketGen.gen("Eth").add("IP").add("TCP")
      pkt.ip(dst: @dst_ip)
      pkt.tcp(dport: @dst_port, sport: rand(49152..65535), flags: flags, body: payload)
      p pkt.headers.each { |h| p h.to_h rescue nil }
      pkt.to_w("wlo1")
    end
  end
end