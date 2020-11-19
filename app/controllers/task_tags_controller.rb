# frozen_string_literal: true

class TaskTagsController < ApplicationController
  before_action :set_task_tag, only: [:show, :edit, :update, :destroy]
  before_action :check_params_date, only: [:new]

  def index
    @task_tags = current_user.task_tags.all
  end

  def show
    @tasks = current_user.tasks.where(task_tag_id: @task_tag.id).recent
  end

  def new
    @task_tag = TaskTag.new
  end

  def create
    @task_tag = TaskTag.new(task_tag_params)
    if @task_tag.save
      flash[:notice] = "新規タグ「#{@task_tag.name}」を登録"
      redirect_to task_tags_url
    else
      render("/task_tags/new")
    end
  end

  def edit; end

  def update
    if @task_tag.update(task_tag_params)
      flash[:notice] = "タグ「#{@task_tag.name}」の変更を保存"
      redirect_to task_tags_url
    else
      render("/task_tags/edit")
    end
  end

  def destroy
    @task_tag.destroy
    flash[:notice] = "「#{@task_tag.name}」を削除"
    redirect_to task_tags_url
  end

  private

  def task_tag_params
    params.require(:task_tag).permit(
      :name
    ).merge(user_id: current_user.id)
  end

  def set_task_tag
    if current_user.task_tags.exists?(id: params[:id])
      @task_tag = current_user.task_tags.find(params[:id])
    else
      flash[:notice] = "存在しないタグです。"
      redirect_to task_tags_url
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
