class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.new(like_params)
    if @like.likeable.author != current_user
      unless @like.save
        flash[:notice] = @like.errors.full_messages.to_sentence
      end
    end
    redirect_back(fallback_location: questions_url)
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy

    redirect_back(fallback_location: questions_url)
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type, :state)
  end
end
