class SeatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "SeatChannel"
  end
end
