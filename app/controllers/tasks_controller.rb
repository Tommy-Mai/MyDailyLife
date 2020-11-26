# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_params_date, only: [:new]

  def show
    @tag = TaskTag.find_by(id: @task.task_tag_id)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      othertask_create
      flash[:notice] = "「#{@task.name}」を登録"
      redirect_to task_url(@task)
    else
      render("tasks/new")
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:notice] = "#{@task.date.strftime('%Y-%m-%d')}「#{@task.name}」の変更を保存"
      redirect_to task_url
    else
      render("tasks/edit")
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "#{@task.date.strftime('%Y-%m-%d')}「#{@task.name}」を削除"
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(
      :name,
      :description,
      :task_tag_id,
      :date,
      :with_whom,
      :where,
      :time
    ).merge(user_id: current_user.id)
  end

  def set_task
    if current_user.tasks.exists?(id: params[:id])
      @task = current_user.tasks.find(params[:id])
    else
      flash[:notice] = "存在しないタスクです。"
      redirect_to "/users/#{current_user.id}/other_tasks"
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
