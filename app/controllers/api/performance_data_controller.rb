class Api::PerformanceDataController < ApplicationController
  before_action :authenticate_user!

  def create
    data = current_user.performance_data.create(performance_data_params)
    if data.persisted?
      render status: 201
    else
      render json: { error: data.errors.full_messages }
    end
  end

  def index
    collection = current_user.performance_data
    render json: { entries: collection }
  end

  private

  def performance_data_params
    params.require(:performance_data).permit!
  end
end
