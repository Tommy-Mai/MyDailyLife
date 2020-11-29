# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :time_out, only: [:new, :create, :destroy]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :forbid_login_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      user_last_login_at
      session_last_activity_at
      redirect_to user_url(@user), notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def show
    @user = current_user
    @q = current_user.meal_tasks.ransack(params[:q])
    @meal_tasks = @q.result(distinct: true).page(params[:page]).per(5).recent
  end

  def other_tasks
    @user = current_user
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(5).recent
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.id == 1
      redirect_to user_url(@user), notice: "このアカウントは編集できません。"
    elsif @user.update(user_params_update)
      redirect_to user_url(@user), notice: "「#{@user.name}」の情報を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    user_last_logout_at
    @user = current_user
    if @user.image_name.attached?
      @user.image_name.purge
    end
    @user.destroy
    reset_session
    redirect_to :new, notice: "ユーザー「#{@user.id}」を削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :image_name
    ).merge(admin: false, image_exist: true)
  end

  def user_params_update
    if params[:user][:image_name]
      if @user.image_name.attached?
        @user.image_name.purge
      end
      params[:image_exist] = true
    elsif @user.image_name.attached?
      params[:image_exist] = true
    else
      params[:image_exist] = false
    end
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :image_name
    ).merge(image_exist: params[:image_exist])
  end

  def ensure_correct_user
    return unless current_user.id != params[:id].to_i

    flash[:notice] = "存在しないページです。"
    redirect_to("/calendar/index")
  end
end
