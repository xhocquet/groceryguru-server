class StoresController < ApplicationController
   def search
    render json: Store.search(params[:query]).to_json
  end
end
