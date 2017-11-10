class Admin::SubmissionsController < ApplicationController
  before_action :validate_admin, :load_submission

  def validate
    klass = submission_model_class
    new_record = klass.new name: @submission.value.downcase

    if new_record.save
      @submission.accepted!
      flash[:notice] = "Submission successfully persisted"
    else
      flash[:error] = "Submission count not be persisted, please try again"
    end
    redirect_to submission_index_path
  end

  def destroy
    if @submission.rejected!
      flash[:notice] = "Submission successfully removed"
    else
      flash[:error] = "Submission could not be destroyed"
    end
    redirect_to submission_index_path
  end

  private

  def submission_model_class
    if @submission.model_type == 'store'
      return ::Store
    elsif @submission.model_type == 'item'
      return ::Item
    end
  end

  def submission_index_path
    if @submission.model_type == 'store'
      admin_stores_submissions_path
    else
      admin_items_submissions_path
    end
  end

  def load_submission
    @submission = Submission.find(params[:id] || params[:submission_id])
  end
end