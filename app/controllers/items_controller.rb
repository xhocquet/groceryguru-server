class ItemsController < ApplicationController 
  def search
    render json: Item.search(params[:query]).to_json
  end
end
