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
    options = {}
    options[:alpha] = params[:alpha]

    if Item.where("id > ?", @item.id).first
      next_item = Item.where("id > ?", @item.id).first
      options[:anchor] = "item-anchor-#{next_item.id}"
    end

    if @item.destroy
      flash[:notice] = "Item destroyed"
    else
      flash[:error] = "Could not destroy item"
    end
    redirect_to admin_items_path(options)
  end

  def submissions
    @submissions = Submission.where(model_type: :item)
    render 'admin/submissions'
  end

  def search
    render json: Item.fuzzy_search(params[:query]).records.to_json(:include => :mode)
  end
end
