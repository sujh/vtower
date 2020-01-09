class TasksController < ApplicationController

  def create
    list = List.find(params[:list_id])
    task = list.tasks.build(task_params)
    if task.save
      render json: { status: 0, msg: 'ok', data: task.as_json(only: [:id, :title, :content]) }
    else
      render json: { status: -1, msg: task.error_msg }
    end
  end

  def update
    task = Task.find(params[:id])
    if task.update(task_params)
      render json: { status: 0, msg: 'ok' }
    else
      render json: { status: -1, msg: task.error_msg }
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    render json: { status: 0, msg: 'ok' }
  end

  private

    def task_params
      params.require(:task).permit(:content, :title, :status)
    end

end