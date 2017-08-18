class ItemsController < ApplicationController
  before_action :validate_admin, except: :search

  def index
    if params[:alpha].present?
      items = Item.arel_table
      @items = Item.where(items[:name].matches("#{params[:alpha]}%")).includes(:mode).order(:name)
    else
      @items = Item.all.includes(:mode).order(:name)
    end
  end

  def destroy
    @item = Item.find(params[:id])
    if @item.destroy
      flash[:notice] = "Successfully destroyed item"
      redirect_to request.referer
    else
      flash[:error] = "Could not destroy item"
      redirect_to request.referer
    end
  end

  def search
    render json: Item.search(params[:query]).to_json(:include => :mode)
  end
end
