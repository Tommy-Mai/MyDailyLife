# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :time_out
  before_action :forbid_login_user, only: [:new, :create]

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      user_last_login_at
      session_last_activity_at
      redirect_to user_url(user), notice: 'ログインしました。'
    else
      @error_message = "メールアドレスまたはパスワードが間違っています。"
      render :new
    end
  end

  def destroy
    user_last_logout_at
    test_user_logout
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
