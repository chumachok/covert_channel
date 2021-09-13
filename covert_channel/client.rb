require "packetgen"
require "macaddr"
require_relative "constants"

module CovertChannel
  class Client
    PCAP_PATH = File.join(__dir__, "..", "fixtures", "dns.pcap")
    SECRET_MESSAGE = "(._.)\n\n"

    def initialize(dst_ip:, message: SECRET_MESSAGE, dst_port: DNS_PORT)
      @dst_ip = dst_ip
      @dst_port = dst_port
      @message = message
    end

    def call
      @message.each_char do |char|
        send_packet(char)
        sleep(DELAY)
      end
    end

    private

    def send_packet(payload)
      dns_packets = PacketGen.read(PCAP_PATH)
      base_packet = dns_packets.sample
      base_packet.eth(src: Mac.addr)
      base_packet.ip(id: rand(0..65535), dst: @dst_ip, ttl: payload.ord + DEFAULT_MIN_TTL)
      base_packet.udp(dport: @dst_port, sport: rand(49152..65535))
      base_packet.to_w
    end
  end
end



