class Admin::SubmissionsController < ApplicationController
  before_action :load_submission

  def validate

  end

  def destroy
    if @submission.destroy
      flash[:notice] = "Submission successfully removed"
    else
      flash[:error] = "Submission could not be destroyed"
    end
    redirect_to send("admin_#{@submission.model_type}s_submissions_path")
  end

  private

  def load_submission
    @submission = Submission.find(params[:id])
  end
end