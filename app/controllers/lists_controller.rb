class ListsController < ApplicationController

  def create
    plan = Plan.find(params[:plan_id])
    list = plan.lists.new(list_params)
    if list.save
      render json: { status: 0, msg: 'ok', data: list.as_json(only: [:id, :title]) }
    else
      render json: { status: -1, msg: list.error_msg }
    end
  end

  def update
    list = List.find(params[:id])
    if list.update(list_params)
      render json: { status: 0, msg: 'ok' }
    else
      render json: { status: -1, msg: list.error_msg }
    end
  end

  def destroy
    List.find(params[:id]).destroy
    render json: { status: 0, msg: 'ok' }
  end

  private

    def list_params
      params.require(:list).permit(:title)
    end

end
