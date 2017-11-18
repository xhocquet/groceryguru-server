class Admin::ItemsController < AdminController
  def index
    if params[:alpha].present?
      items = Item.arel_table
      @items = Item.where(items[:name].matches("#{params[:alpha]}%")).order(:name)
    else
      @items = Item.all.order(:name)
    end
  end

  def create
    new_item = Item.new item_params

    if new_item.save
      flash[:notice] = "Store created"
    else
      flash[:error] = "Store could not be created"
    end
    redirect_to admin_items_submissions_path
  end

  def submissions
    @submissions = Submission.where(model_type: :item).needs_sorting.order(:created_at).page(params[:page])
  end

  def validate_all_submissions
    @submissions = Submission.where(model_type: :item).needs_sorting

    Submission.transaction do
      @submissions.each do |submission|
        item = Item.new(
          name: submission.value,
          submission: submission,
        )
        item.save!
      end
    end

    flash[:notice] = "#{@submissions.size} items created"
    redirect_to admin_items_submissions_path
  end

  def destroy
    @item = Item.find(params[:id])
    options = {}
    options[:alpha] = params[:alpha]

    if Item.where("id > ?", @item.id).first
      next_item = Item.where("id > ?", @item.id).first
      options[:anchor] = "item-anchor-#{next_item.id}"
    end

    if @item.destroy
      flash[:notice] = "Item destroyed"
    else
      flash[:error] = "Could not destroy item"
    end
    redirect_to admin_items_path(options)
  end

  private

  def item_params
    params.require(:item).permit(:name, :group_id, :submission_id)
  end
end
