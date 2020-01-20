class PlansController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        plans = Plan.accessible_by(current_ability)
        render json: { status: 0, msg: 'ok', data: { plans: plans.as_json(only: [:id, :title, :description]) }}
      end
    end
  end

  def show
    @plan = Plan.find(params[:id])
    authorize! :read, @plan
    respond_to do |format|
      format.html
      format.json do
        @lists = @plan.lists.includes(:tasks)
        render json: { status: 0, msg: 'ok', data: {
            plan: @plan.as_json(only: [:id, :title, :description]),
            lists: @lists.as_json(only: [:id, :title], include: { tasks: { only: [:id, :title, :content, :status] }}) } }
      end
    end
  end

  def create
    authorize! :create, Plan
    plan = current_user.plans.new(plan_params)
    if plan.save
      render json: { status: 0, msg: 'ok', data: { id: plan.id } }
    else
      render json: { status: -1, msg: plan.error_msg }
    end
  end

  def update
    plan = Plan.find(params[:id])
    authorize! :update, plan
    if plan.update(plan_params)
      render json: { status: 0, msg: 'ok' }
    else
      render json: { status: -1, msg: plan.error_msg }
    end
  end

  def destroy
    plan = Plan.find(params[:id])
    authorize! :destroy, plan
    plan.destroy
    render json: { status: 0, msg: 'ok' }
  end

  private

    def plan_params
      params.require(:plan).permit(:title, :description)
    end

end