require_relative "covert_channel/client"

CovertChannel::Client.new(dst_ip: "127.0.0.1", dst_port: 3003).call