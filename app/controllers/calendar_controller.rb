# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    @mealtasks = current_user.meal_tasks.all
  end

  def show
    @date = params[:start_date]
    @meal_tasks = current_user.meal_tasks.where(:date => @date)
  end
end
