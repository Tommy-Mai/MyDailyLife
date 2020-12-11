# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :time_out
  before_action :forbid_login_user, only: [:new, :create]

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user.logged_in == false
      user_login
    elsif user.logged_in == true && user.last_activity_at.to_time.since(31.minutes) < Time.current
      test_user_reset
      user_loggedin_false
      user_login
    else
      redirect_back(fallback_location: root_path)
      flash[:notice] = "別のデバイスでログイン中です。\nしばらく時間をおいて再度お試しください。"
    end

  end

  def destroy
    user_last_logout_at
    user_loggedin_false
    test_user_reset
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def user_login
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      test_user_reset
      user_loggedin_true
      user_last_login_at
      session_last_activity_at
      redirect_to user_url(user), notice: 'ログインしました。'
    else
      @error_message = "メールアドレスまたはパスワードが間違っています。"
      render :new
    end
  end
end
