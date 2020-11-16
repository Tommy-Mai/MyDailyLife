# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to meal_tasks_url, notice: 'ログインしました。'
    else
      @error_message = "メールアドレスまたはパスワードが間違っています。"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
