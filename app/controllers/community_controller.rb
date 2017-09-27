class CommunityController < ApplicationController
  def index
    @submissions = current_user.submissions
  end

  def create_item_submission
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

  def create_store_submission
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

  private

  def submission_params
    params.require(:submission).permit(:value).merge({ model_type: :store, user: current_user })
  end

  def item_submission_params
    params.require(:item_submission).permit(:value).merge({ model_type: :item, user: current_user })
  end

  def mode_submission_params
    params.require(:mode_submission).permit(:value).merge({ model_type: :mode, user: current_user })
  end
end