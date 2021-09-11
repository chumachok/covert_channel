require "packetgen"

module CovertChannel
  class Connection

    attr_accessor :state, :iface

    IFACE = "wlo1"

    STATES = [
      STATE_IDLE = "idle",
      STATE_INITIATED = "initiated",
      STATE_ESTABLISHED = "established",
      STATE_CLOSED = "closed",
    ].freeze

    FLAGS = [
      FIN = 0x1001,
      SYN = 0x1002,
      PSH = 0x1008,
      ACK = 0x1010,
    ].freeze

    def initialize(dst_ip:, dst_port:)
      @dst_ip = dst_ip
      @dst_port = dst_port
      @state = STATE_IDLE
      @iface = IFACE
    end

    def send_packet(flags:, payload: "", seqnum: nil, acknum: nil)
      packet = PacketGen.gen("Eth").add("IP").add("TCP")
      packet.ip(dst: @dst_ip)
      packet.tcp(dport: @dst_port, sport: rand(49152..65535), flags: flags, body: payload)
      packet.tcp.seqnum = seqnum if seqnum
      packet.tcp.acknum = acknum if acknum
      p packet
      packet.to_w(@iface)
    end

  end
end