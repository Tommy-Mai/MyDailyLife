# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_url(@user), notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.id == 1 || @user.id == 2
      redirect_to user_url(@user), notice: "このアカウントは編集できません。"
    elsif @user.update(user_params)
      redirect_to user_url(@user), notice: "「#{@user.name}」の情報を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    session[:user_id].clear
    redirect_to :new, notice: "ユーザー「#{@user.id}」を削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :admin,
      :password,
      :password_confirmation
    ).merge(admin: false)
  end

  def ensure_correct_user
    return unless current_user.id != params[:id].to_i

    flash[:notice] = "存在しないページです。"
    redirect_to("/calendar/index")
  end
end
