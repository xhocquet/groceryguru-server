class Admin::StoresController < AdminController
  def index
    if params[:alpha].present?
      stores = Store.arel_table
      @stores = Store.where(stores[:name].matches("#{params[:alpha]}%")).order(:name)
    else
      @stores = Store.all.order(:name)
    end
  end

  def create
    new_store = Store.new store_params

    if new_store.save
      new_store.submission.accepted!
      flash[:notice] = "Store created"
    else
      flash[:error] = "Store could not be created"
    end
    redirect_to admin_stores_path
  end

  def submissions
    @submissions = Submission.where(model_type: :store).needs_sorting.order(:created_at).page(params[:page])
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

  private

  def store_params
    params.require(:store).permit(:name, :postal_code, :submission_id)
  end
end