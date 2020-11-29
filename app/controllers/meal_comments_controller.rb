class MealCommentsController < ApplicationController
  def create
    @meal_comment = MealComment.new(meal_comment_params)
    if @meal_comment.save
      comment_create
      respond_to do |format|
        format.html { redirect_to meal_task_path(@meal_comment.task_id) }
        format.json
      end
    else
      render meal_task_path(@meal_comment.task_id)
    end
  end

  def destroy
    @meal_comment = MealComment.find_by(id: params[:id])
    if @meal_comment.image.attached?
      @meal_comment.image.purge
    end
    @meal_comment.destroy
  end

  private

  def meal_comment_params
    params.permit(
      :comment,
      :task_id,
      :image
    ).merge(user_id: current_user.id)
  end
end
