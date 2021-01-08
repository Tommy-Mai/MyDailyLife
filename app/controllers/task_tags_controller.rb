# frozen_string_literal: true

class TaskTagsController < ApplicationController
  before_action :set_task_tag, only: [:show, :update, :destroy]
  before_action :check_params_date, only: [:new]

  def index
    @task_tag = TaskTag.new
    @q = current_user.task_tags.ransack(params[:q])
    @tags = @q.result(distinct: true).page(params[:page]).per(5).recent
  end

  def meal_tags
    @tags = MealTag.all.number
  end

  def show
    @tasks = current_user.tasks.where(task_tag_id: @task_tag.id).page(params[:page]).per(10).recent
  end

  def create
    @task_tag = TaskTag.new(task_tag_params)
    if @task_tag.save
      tag_create
      respond_to do |format|
        format.html { redirect_to task_tags_path }
        format.json
      end
    else
      redirect_to task_tags_path
    end
  end

  def update
    if @task_tag.protected == true
      flash[:notice] = "編集できないタグです。"
      redirect_to task_tags_url
    elsif @task_tag.update(task_tag_params)
      respond_to do |format|
        format.html { redirect_to task_tags_path }
        format.json
      end
    else
      redirect_to task_tags_path
    end
  end

  def destroy
    if @task_tag.protected == true
      flash[:notice] = "削除できないタグです。"
      redirect_to task_tags_url
    else
      @task_tag.destroy
    end
  end

  private

  def task_tag_params
    params.permit(
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
