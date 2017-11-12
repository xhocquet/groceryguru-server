class ItemsController < ApplicationController
  def search
    render json: Item.fuzzy_search(params[:query]).records.to_json
  end
end
