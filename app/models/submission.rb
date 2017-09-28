class Submission < ApplicationRecord
  belongs_to :user, inverse_of: :submissions

  enum status: [:pending, :rejected, :accepted]

  scope :needs_sorting, -> { where(status: 0) }

  after_save :send_email_notifications, on: :update

  paginates_per 10

  private

  def send_email_notifications
    return unless status_before_last_save == "pending"
    UserMailer.submission_notification_email(self).deliver_later
  end
end
