class UserMailerPreview < ActionMailer::Preview
  def submission_notification_email_accepted
    UserMailer.submission_notification_email(Submission.accepted.first)
  end

  def submission_notification_email_rejected
    UserMailer.submission_notification_email(Submission.rejected.first)
  end
end