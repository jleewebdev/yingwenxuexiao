class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :practice_option_check, :require_paid_membership, :unread_notifications_count

  def unread_notifications_count
    CommentNotification.all_unread.count
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_paid_membership
    if !logged_in?
      flash[:danger] = "需先登入才能使用" # You need to be logged in to do that
      redirect_to sign_in_path
    elsif !current_user.is_paid_member?
      flash[:danger] = "需为高级会员才能使用" # You need to have a premium account to do that.
      redirect_to upgrade_path
    end
  end


  def require_user
    redirect_to sign_in_path unless current_user
  end

  def require_admin
    unless logged_in? && current_user.is_admin? || logged_in? && current_user.is_editor?
      flash[:danger] = "You do not have permission to do that"
      redirect_to root_path
    end
  end
end
