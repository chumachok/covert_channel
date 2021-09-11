module CovertChannel
  class Connection

    attr_reader :state

    STATE_IDLE = "idle"
    STATE_INITIATED = "initiated"
    STATE_ESTABLISHED = "established"
    STATE_CLOSED = "closed"

    def intialize
      @state = STATE_IDLE
    end
  end
end