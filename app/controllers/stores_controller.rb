class StoresController < ApplicationController
  before_action :validate_admin, except: :search

  def index
    if params[:alpha].present?
      stores = Store.arel_table
      @stores = Store.where(stores[:name].matches("#{params[:alpha]}%"))
    else
      @stores = Store.all
    end
  end

  def search
    render json: Store.search(params[:query]).to_json
  end
end
