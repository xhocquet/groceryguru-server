class Submission < ApplicationRecord
  belongs_to :user, inverse_of: :submissions

  enum status: [:pending, :rejected, :accepted]

  scope :needs_sorting, -> { where(status: 0) }

  after_update :send_email_notifications

  # TODO: This needs to be a polymorphic relationship, but then
  # the key needs to be on submissions
  def accepted_value
    model_type.titleize.constantize.find_by(submission: self)
  end

  private

  def send_email_notifications
    return unless self.status_before_last_save == "pending"
    UserMailer.submission_notification_email(self).deliver_later
  end
end
