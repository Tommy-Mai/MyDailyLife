# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    if params[:start_date]
      @date = params[:start_date].to_date
    else
      @date = Date.current
    end

    # 現在の月+前後1週間のデータを取得し、正しくカレンダーにタスク数が表示されるように絞り込み
    @meal_tasks = current_user.meal_tasks.where(
      "date >= :last_month AND date <= :next_month",
      {
        last_month: @date.last_month.end_of_month.beginning_of_week,
        next_month: @date.next_month.beginning_of_month.end_of_week
      }
    )

    @tasks = current_user.tasks.where(
      "date >= :last_month AND date <= :next_month",
      {
        last_month: @date.last_month.end_of_month.beginning_of_week,
        next_month: @date.next_month.beginning_of_month.end_of_week
      }
    )
  end

  def show
    if params[:start_date]
      @date = params[:start_date].to_date
    else
      @date = Date.current
    end
    @meal_tasks = current_user.meal_tasks.where(date: @date.all_day)
  end

  def other_tasks
    if params[:start_date]
      @date = params[:start_date].to_date
    else
      @date = Date.current
    end
    @tasks = current_user.tasks.where(date: @date.all_day)
    if current_user.task_tags.exists?(id: params[:id])
      @task_tag = true
    else
      @task_tag = false
    end
  end
end
