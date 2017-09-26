class AdminController < ApplicationController
  before_action :validate_admin

  def index
  end

  def store_submissions
    @submissions = Submission.where(model_type: :store).needs_sorting
    render 'submissions'
  end

  def item_submissions
    @items_controller = true
    @submissions = Submission.where(model_type: [:item, :mode]).needs_sorting
    render 'submissions'
  end
end
