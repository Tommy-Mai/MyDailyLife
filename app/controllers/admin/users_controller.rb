class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    if @user.id == 1 or 2
      redirect_to admin_users_index_url, notice: "このユーザーは削除できません。"
    else
      @user.destroy
      redirect_to admin_users_index_url, notice: "ユーザー「#{@user.name}」を削除しました。"
    end
  end

  private

  def require_admin
    redirect_to meal_tasks_url, notice: "権限がありません。" unless current_user.admin?
  end
  
end
