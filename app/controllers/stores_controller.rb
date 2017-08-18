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
    @next_store = Store.where("id > ?", @store.id).first
    alpha = params[:alpha]

    if @store.destroy
      flash[:notice] = "Successfully destroyed store"
      redirect_to admin_stores_path(alpha: alpha, anchor: "store-anchor-#{@next_store.id}")
    else
      flash[:error] = "Could not destroy store"
      redirect_to admin_stores_path(alpha: alpha, anchor: "store-anchor-#{@next_store.id}")
    end
  end

  def search
    render json: Store.search(params[:query]).to_json
  end
end
