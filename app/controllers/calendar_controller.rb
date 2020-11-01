class CalendarController < ApplicationController
  def index
    @mealtasks = MealTask.all
  end
end