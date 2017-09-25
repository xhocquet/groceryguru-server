class ItemsController < ApplicationController
  before_action :validate_admin, except: [:search, :create_submission]

  def index
    if params[:alpha].present?
      items = Item.arel_table
      @items = Item.where(items[:name].matches("#{params[:alpha]}%")).includes(:mode).order(:name)
    else
      @items = Item.all.includes(:mode).order(:name)
    end
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

  def submissions
    @items_controller = true
    @submissions = Submission.where(model_type: [:item, :mode]).needs_sorting
    render 'admin/submissions'
  end

  def new_submission
    render 'community/submit_item'
  end

  def create_submission
    @item_submission = Submission.new item_submission_params
    @mode_submission = Submission.new mode_submission_params

    if @item_submission.save && @mode_submission.save
      # TODO: Logic for users with direct permission
      flash[:notice] = "You submission will be reviewed and accepted shortly"
      redirect_to community_new_item_path
    else
      flash[:error] = "Could not create the submission, please try again"
      redirect_to community_new_item_path
    end
  end

  def search
    render json: Item.fuzzy_search(params[:query]).records.to_json(:include => :mode)
  end

  private

  def item_submission_params
    params.require(:item_submission).permit(:value).merge({ model_type: :item, user: current_user })
  end

  def mode_submission_params
    params.require(:mode_submission).permit(:value).merge({ model_type: :mode, user: current_user })
  end
end
