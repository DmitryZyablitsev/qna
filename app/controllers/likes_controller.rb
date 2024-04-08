class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.new(like_params)

    respond_to do |format|
      if @like.likeable.author != current_user && @like.save
        format.html { render partial: 'likes/button', locals: { resource: @like.likeable } }
      else
        format.html do
          render partial: 'shared/errors', locals: { resource: @like }, status: :unprocessable_entity
        end
      end
    end
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
