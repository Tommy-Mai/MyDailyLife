class MealTagsController < ApplicationController
  
  def index
    @meal_tag = MealTag.find(params[:id])
    @meal_tasks = current_user.meal_tasks.where(meal_tag_id: @meal_tag.id).recent
  end
  
end