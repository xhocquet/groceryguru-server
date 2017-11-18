class Admin::SubmissionsController < ApplicationController
  before_action :validate_admin, :load_submission

  def destroy
    if @submission.rejected!
      flash[:notice] = "Submission successfully removed"
    else
      flash[:error] = "Submission could not be destroyed"
    end
    redirect_to :back
  end

  private

  def load_submission
    @submission = Submission.find(params[:id] || params[:submission_id])
  end
end