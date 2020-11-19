# frozen_string_literal: true

class MealTasksController < ApplicationController
  before_action :set_meal_task, only: [:show, :edit, :update, :destroy]
  before_action :check_params_date, only: [:new]

  def index
    @meal_tasks = current_user.meal_tasks.recent
  end

  def show
    @tag = MealTag.find_by(id: @meal_task.meal_tag_id)
  end

  def new
    @meal_task = MealTask.new
  end

  def create
    @meal_task = MealTask.new(meal_task_params)
    if @meal_task.save
      flash[:notice] = "「#{@meal_task.name}」を登録"
      redirect_to meal_task_url(@meal_task)
    else
      render("meal_tasks/new")
    end
  end

  def edit; end

  def update
    if @meal_task.update(meal_task_params)
      flash[:notice] = "#{@meal_task.date.strftime('%Y-%m-%d')}「#{@meal_task.name}」の変更を保存"
      redirect_to meal_task_url
    else
      render("meal_tasks/edit")
    end
  end

  def destroy
    @meal_task.destroy
    flash[:notice] = "#{@meal_task.date.strftime('%Y-%m-%d')}「#{@meal_task.name}」を削除"
    redirect_to meal_tasks_url
  end

  private

  def meal_task_params
    params.require(:meal_task).permit(
      :name,
      :description,
      :meal_tag_id,
      :date,
      :with_whom,
      :where,
      :time
    ).merge(user_id: current_user.id)
  end

  def set_meal_task
    if current_user.meal_tasks.exists?(id: params[:id])
      @meal_task = current_user.meal_tasks.find(params[:id])
    else
      flash[:notice] = "存在しないタスクです。"
      redirect_to meal_tasks_url
    end
  end

  def check_params_date
    if params[:date]
      @date = params[:date].to_date
    else
      @date = Date.current
    end
  end
end
