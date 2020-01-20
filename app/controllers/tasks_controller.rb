class TasksController < ApplicationController

  def create
    list = List.find(params[:list_id])
    task = list.tasks.build(task_params.merge({ user_id: current_user.id }))
    authorize! :manage, list
    authorize! :create, task
    if task.save
      render json: { status: 0, msg: 'ok', data: task.as_json(only: [:id, :title, :content]) }
    else
      render json: { status: -1, msg: task.error_msg }
    end
  end

  def update
    task = authorize!(:update, Task.find(params[:id]))
    if task.update(task_params)
      render json: { status: 0, msg: 'ok' }
    else
      render json: { status: -1, msg: task.error_msg }
    end
  end

  def destroy
    authorize!(:destroy, Task.find(params[:id])).destroy
    render json: { status: 0, msg: 'ok' }
  end

  private

    def task_params
      params.require(:task).permit(:content, :title, :status, :list_id)
    end

end