# frozen_string_literal: true

class TaskCommentsController < ApplicationController
  def create
    @task_comment = TaskComment.new(task_comment_params)
    images_count
    if @images_count >= 5
      render template: 'tasks/show', notice: "投稿できる画像は1ユーザーにつき5枚までです。"
    elsif @task_comment.save
      comment_create
      respond_to do |format|
        format.html { redirect_to task_path(id: @task_comment.task_id) }
        format.json
      end
    else
      render template: 'tasks/show'
    end
  end

  def destroy
    @task_comment = TaskComment.find_by(id: params[:id])
    if @task_comment.protected == true
      flash[:notice] = "削除できないコメントです。"
      redirect_to task_url(@task)
    else
      @task_comment.image.purge_later if @task_comment.image.attached?
      @task_comment.destroy
    end
  end

  private

  def task_comment_params
    params.permit(
      :comment,
      :task_id,
      :image,
      :image_exist
    ).merge(user_id: current_user.id)
  end
end
