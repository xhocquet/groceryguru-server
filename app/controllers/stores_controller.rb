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
    options = {}
    options[:alpha] = params[:alpha]

    if Store.where("id > ?", @store.id).first
      next_store = Store.where("id > ?", @store.id).first
      options[:anchor] = "store-anchor-#{next_store.id}"
    end

    if @store.destroy
      flash[:notice] = "Store destroyed"
    else
      flash[:error] = "Could not destroy store"
    end
    redirect_to admin_stores_path(options)
  end

  def create_submission
    redirect_to community_new_store_path
  end

  def search
    render json: Store.search(params[:query]).to_json
  end
end
