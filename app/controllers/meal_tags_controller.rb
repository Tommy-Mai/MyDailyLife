class MealTagsController < ApplicationController
  
  def index
    @meal_tags = MealTag.find_by(id: params[:id])
    @meal_tasks = MealTask.where(meal_tag_id: @meal_tags.id).order(date: :desc,time: :desc)
  end
  
end