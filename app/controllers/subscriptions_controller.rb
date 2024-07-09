class SubscriptionsController < ApplicationController

  authorize_resource

  def create
    @subscription = current_user.subscriptions.new(subscription_params)

    @subscription.save
    redirect_to @subscription.question, notice: 'You subscribed to the question'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to @subscription.question, notice: 'You have unsubscribed from the question'
  end

  private

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
