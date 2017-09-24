class Admin::SubmissionsController < ApplicationController
  before_action :load_submission

  def validate
    klass = @submission.model_type.classify.constantize
    new_record = klass.new validated_submission_value_param
    if new_record.save
      flash[:notice] = "Submission successfully persisted"
      @submission.destroy
    else
      flash[:error] = "Submission count not be persisted, please try again"
    end
    redirect_to send("admin_#{@submission.model_type}s_submissions_path")
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
    @submission = Submission.find(params[:id] || params[:submission_id])
  end

  def validated_submission_value_param
    params.require(:submission).permit(:name)
  end
end