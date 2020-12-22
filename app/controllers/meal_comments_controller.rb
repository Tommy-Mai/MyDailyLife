# frozen_string_literal: true

class MealCommentsController < ApplicationController
  def create
    @meal_comment = MealComment.new(meal_comment_params)
    images_count
    if @images_count >= 5
      render template: 'tasks/show', notice: "投稿できる画像は1ユーザーにつき5枚までです。"
    elsif @meal_comment.save
      comment_create
      respond_to do |format|
        format.html { redirect_to meal_task_path(id: @meal_comment.task_id) }
        format.json
      end
    else
      render template: 'meal_tasks/show'
    end
  end

  def destroy
    @meal_comment = MealComment.find_by(id: params[:id])
    if @meal_comment.protected == true
      flash[:notice] = "削除できないコメントです。"
      redirect_to meal_task_url(@meal_task)
    else
      @meal_comment.image.purge_later if @meal_comment.image.attached?
      @meal_comment.destroy
    end
  end

  private

  def meal_comment_params
    params.permit(
      :comment,
      :task_id,
      :image,
      :image_exist,
      :protected
    ).merge(user_id: current_user.id)
  end
end
