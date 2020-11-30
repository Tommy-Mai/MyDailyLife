class TaskCommentsController < ApplicationController
  def create
    @task_comment = TasksComment.new(task_comment_params)
    if @task_comment.save
      comment_create
      respond_to do |format|
        format.html { redirect_to task_path(:id => @task_comment.task_id) }
        format.json
      end
    else
      render template: 'tasks/show'
    end
  end

  def destroy
    @task_comment = TasksComment.find_by(id: params[:id])
    if @task_comment.image.attached?
      @task_comment.image.purge_later
    end
    @task_comment.destroy
  end

  private

  def task_comment_params
    params.permit(
      :comment,
      :task_id,
      :image,
      :image_exist
    ).merge(user_id: current_user.id)
  end
end
