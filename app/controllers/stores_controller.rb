class StoresController < ApplicationController
   def search
    render json: Store::Location.fuzzy_search(params[:query]).records.to_json(methods: :name)
  end
end
