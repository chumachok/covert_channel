
require_relative "covert_channel/server"

CovertChannel::Server.new(listen_port: 3003).call
