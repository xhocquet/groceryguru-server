class ItemsController < ApplicationController
  def search
    render json: Item.fuzzy_search(params[:query]).to_json
  end
end
