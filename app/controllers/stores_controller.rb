class StoresController < ApplicationController
   def search
    render json: Store.fuzzy_search(params[:query]).to_json
  end
end
