class StoresController < ApplicationController
  before_action :validate_admin, except: :search

  def index
    if params[:alpha].present?
      stores = Store.arel_table
      @stores = Store.where(stores[:name].matches("#{params[:alpha]}%")).order(:name)
    else
      @stores = Store.all.order(:name)
    end
  end

  def destroy
    @store = Store.find(params[:id])
    if @store.destroy
      flash[:notice] = "Successfully destroyed store"
      redirect_to request.referer
    else
      flash[:error] = "Could not destroy store"
      redirect_to request.referer
    end
  end

  def search
    render json: Store.search(params[:query]).to_json
  end
end
