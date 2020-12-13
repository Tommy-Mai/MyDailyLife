class UserMemosController < ApplicationController
  before_action :set_memo, only: [:update, :destroy]

  def create
    @user = current_user
    @memo = UserMemo.new(memo_params)
    if @memo.save
      memo_create
      respond_to do |format|
        format.html { redirect_to "/users/#{@user.id}/memos" }
        format.json
      end
    else
      render template: 'users/memo'
    end
  end

  def update
    @user = current_user
    if @memo.update(memo_params)
      memo_create
      respond_to do |format|
        format.html { redirect_to "/users/#{@user.id}/memos" }
        format.json
      end
    else
      render template: 'users/memo'
    end
  end

  def destroy
    if @memo.protected == true
      flash[:notice] = "削除できないコメントです。"
      redirect_to task_url(@task)
    else
      @memo.destroy
    end
  end

  private

  def memo_params
    params.permit(
      :name,
      :description
    ).merge(user_id: current_user.id)
  end

  def set_memo
    if current_user.user_memos.exists?(id: params[:id])
      @memo = current_user.user_memos.find(params[:id])
    else
      flash[:notice] = "存在しないメモです。"
      redirect_to "/users/#{current_user.id}/memos"
    end
  end
  
end
