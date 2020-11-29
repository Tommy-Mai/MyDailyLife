class MealCommentsController < ApplicationController
  def create
    @meal_comment = MealComment.new(meal_comment_params)
    if @meal_comment.save
      comment_create
      respond_to do |format|
        format.html { redirect_to meal_task_path(:id => @meal_comment.task_id) }
        format.json
      end
    else
      render template: 'meal_tasks/show'
    end
  end

  def destroy
    @meal_comment = MealComment.find_by(id: params[:id])
    if @meal_comment.image.attached?
      @meal_comment.image.purge_later
    end
    @meal_comment.destroy
  end

  private

  def meal_comment_params
    params.permit(
      :comment,
      :task_id,
      :image,
      :image_exist
    ).merge(user_id: current_user.id)
  end
end
