# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    @meal_tasks = current_user.meal_tasks.all
  end

  def show
    @date = Date.parse("#{params[:start_date]}")
    @date_params = @date.strftime('%Y-%m-%d 00:00:00')
    @meal_tasks = current_user.meal_tasks.where(date: @date_params)
  end
end
