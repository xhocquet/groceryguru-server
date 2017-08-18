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
    @next_item = Item.where("id > ?", @item.id).first
    alpha = params[:alpha]

    if @item.destroy
      flash[:notice] = "Successfully destroyed item"
      redirect_to admin_items_path(alpha: alpha, anchor: "item-anchor-#{@next_item.id}")
    else
      flash[:error] = "Could not destroy item"
      redirect_to admin_items_path(alpha: alpha, anchor: "item-anchor-#{@next_item.id}")
    end
  end

  def search
    render json: Item.search(params[:query]).to_json(:include => :mode)
  end
end
