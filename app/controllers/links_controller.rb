class LinksController < ApplicationController
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to @link.linkable, alert: exception.default_message = 'The action is impossible'
  end

  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link

    @link.destroy
  end
end
