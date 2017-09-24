class StoresController < ApplicationController
  before_action :validate_admin, except: :search

  def index
    if params[:alpha].present?
      stores = Store.arel_table
      @stores = Store.where(stores[:name].matches("#{params[:alpha]}%")).order(:name)
    else
      @stores = Store.all.order(:name)
    end
  end

  def destroy
    @store = Store.find(params[:id])
    options = {}
    options[:alpha] = params[:alpha]

    if Store.where("id > ?", @store.id).first
      next_store = Store.where("id > ?", @store.id).first
      options[:anchor] = "store-anchor-#{next_store.id}"
    end

    if @store.destroy
      flash[:notice] = "Store destroyed"
    else
      flash[:error] = "Could not destroy store"
    end
    redirect_to admin_stores_path(options)
  end

  def submissions
    @submissions = Submission.where(model_type: :store)
    render 'admin/submissions'
  end

  def create_submission
    @submission = Submission.new submission_params
    if @submission.save
      # TODO: Logic for users with direct permission
      flash[:notice] = "You submission will be reviewed and accepted shortly"
      redirect_to community_new_store_path
    else
      flash[:error] = "Could not create the submission, please try again"
      redirect_to community_new_store_path
    end
  end

  def search
    render json: Store.search(params[:query]).to_json
  end

  private

  def submission_params
    params.require(:submission).permit(:value).merge({ model_type: :store, user: current_user })
  end
end
