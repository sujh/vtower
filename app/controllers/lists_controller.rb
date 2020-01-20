class ListsController < ApplicationController

  def create
    plan = Plan.find(params[:plan_id])
    list = List.new(list_params.merge({user_id: current_user.id}))
    authorize! :manage, plan
    authorize! :create, list
    if list.save
      render json: { status: 0, msg: 'ok', data: list.as_json(only: [:id, :title]) }
    else
      render json: { status: -1, msg: list.error_msg }
    end
  end

  def update
    list = List.find(params[:id])
    authorize! :update, list
    if list.update(list_params)
      render json: { status: 0, msg: 'ok' }
    else
      render json: { status: -1, msg: list.error_msg }
    end
  end

  def destroy
    authorize!(:destroy, List.find(params[:id])).destroy
    render json: { status: 0, msg: 'ok' }
  end

  private

    def list_params
      params.require(:list).permit(:title, :plan_id)
    end

end
