class ItemsController < ApplicationController
  before_action :validate_admin, except: :search

  def index
    if params[:alpha].present?
      items = Item.arel_table
      @items = Item.where(items[:name].matches("#{params[:alpha]}%"))
    else
      @items = Item.all
    end
  end

  def search
    render json: Item.search(params[:query]).to_json(:include => :mode)
  end
end
