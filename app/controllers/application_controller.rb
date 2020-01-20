class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render status: 200, json: { status: -1, msg: 'You are not authorized!' } }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end
end
