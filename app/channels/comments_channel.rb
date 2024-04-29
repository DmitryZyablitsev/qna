class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "CommentsChannel/#{params[:question]}"
  end
end
