class CommunityController < ApplicationController
  def index
    @submissions = current_user.submissions
  end
end