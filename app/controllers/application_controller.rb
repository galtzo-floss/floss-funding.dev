class ApplicationController < ActionController::Base
  helper_method :current_account

  private

  def current_account
    @current_account ||= Account.find_by(id: session[:account_id]) if session[:account_id]
  end

  def authenticate_account!
    redirect_to(new_session_path, alert: "Please sign in") unless current_account
  end
end
