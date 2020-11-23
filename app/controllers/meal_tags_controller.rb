# frozen_string_literal: true

class MealTagsController < ApplicationController
  def show
    @meal_tag = MealTag.find(params[:id])
    @meal_tasks = current_user.meal_tasks.where(meal_tag_id: @meal_tag.id).page(params[:page]).per(10).recent
  end
end
