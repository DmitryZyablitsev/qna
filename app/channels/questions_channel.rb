class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "QuestionsChannel"
    stream_from "QuestionsChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
