# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    @date = params[:start_date].to_date
    # 現在の月+前後一ヶ月のデータを取得し、正しくカレンダーにタスク数が表示されるように絞り込み
    @meal_tasks = current_user.meal_tasks.where("date >= :last_month AND date <= :next_month",
      {last_month: @date.last_month.beginning_of_month, next_month: @date.next_month.end_of_month})
  end

  def show
    @date = params[:start_date].to_date
    @meal_tasks = current_user.meal_tasks.where(date: @date.all_day)
  end
end
