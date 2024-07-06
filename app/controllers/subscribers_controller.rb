class SubscribersController < ApplicationController

  authorize_resource

  def create
    @subscriber = current_user.subscribers.new(subscriber_params)

    @subscriber.save
    redirect_to @subscriber.question, notice: 'You subscribed to the question'
  end

  def destroy
    @subscriber = Subscriber.find(params[:id])
    @subscriber.destroy
    redirect_to @subscriber.question, notice: 'You have unsubscribed from the question'
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:question_id)
  end
end
