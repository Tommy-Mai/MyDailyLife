# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def histories_index
    histories = UsageHistory.all
    @q = histories.ransack(params[:q])
    @histories = @q.result(distinct: true)
  end

  def destroy
    @user = User.find(params[:id])
    if @user.protected == true
      redirect_to admin_users_index_url, notice: "このアカウントは削除できません。"
    else
      @user.destroy
      redirect_to admin_users_index_url, notice: "ユーザー「#{@user.name}」を削除しました。"
    end
  end

  private

  def require_admin
    render("errors/error404") unless current_user.admin?
  end
end
