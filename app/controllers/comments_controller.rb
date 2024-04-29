class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: %i[create]

  def create
    @comment = current_user.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment }
      else
        format.json do
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "CommentsChannel/#{question_id}", { comment: @comment }
    )
  end

  def question_id
    if @comment.commentable.class == Question
      @comment.commentable.id
    else
      @comment.commentable.question_id
    end
  end
end
