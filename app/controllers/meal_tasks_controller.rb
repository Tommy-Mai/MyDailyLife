class MealTasksController < ApplicationController
  def index
    @meal_tasks = MealTask.all.order(date: :desc,time: :desc)
  end

  def show
    @meal_task = MealTask.find_by(id: params[:id])
    @tag = MealTag.find_by(id: @meal_task.meal_tag_id)
  end

  def new
    @meal_task = MealTask.new
  end

  def create
    @meal_task = MealTask.new(meal_task_params)
    if @meal_task.save
      flash[:notice] = "「#{@meal_task.name}」を登録"
      redirect_to meal_tasks_url
    else
      render("meal_tasks/new")
    end
  end
  
  def edit
    @meal_task = MealTask.find(params[:id])
  end

  def update
    @meal_task = MealTask.find(params[:id])
    if @meal_task.update(meal_task_params)
      flash[:notice] = "#{@meal_task.date}「#{@meal_task.name}」の変更を保存"
      redirect_to meal_task_url
    else
      render("meal_tasks/edit")
    end
  end
  
  def destroy
    meal_task = MealTask.find(params[:id])
    meal_task.destroy
    flash[:notice] = "#{meal_task.date}「#{meal_task.name}」を削除"
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
      ).merge(user_id: 1)
  end

end
