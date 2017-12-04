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
    store = Store.find_or_create_by(name: params[:store][:name])
    new_location = Store::Location.new store_params.merge! store: store

    if new_location.save
      flash[:notice] = "Store created"
    else
      flash[:error] = "Store could not be created"
    end
    redirect_to admin_stores_submissions_path
  end

  def submissions
    @submissions = Submission.where(model_type: :store).needs_sorting.order(:created_at).page(params[:page])
  end

  def validate_all_submissions
    @submissions = Submission.where(model_type: :store).needs_sorting

    Submission.transaction do
      @submissions.each do |submission|
        store = Store.new(
          name: submission.value.split(' - ').first,
          postal_code: submission.value.split(' - ').last.match(/\d{5}(-\d{4})?/)[0],
          submission: submission,
        )
        store.save!
      end
    end

    flash[:notice] = "#{@submissions.size} stores created"
    redirect_to admin_stores_submissions_path
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
    params.require(:store).permit(:postal_code, :submission_id)
  end
end