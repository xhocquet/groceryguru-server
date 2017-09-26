class UserMailer < ApplicationMailer
  def submission_notification_email(submission)
    @submission = submission
    @user = submission.user
    subject = @submission.accepted? ?
      "Your #{@submission.model_type} submission has been accepted!" :
      "Your submission has been rejected."

    mail(to: @user.email, subject: subject)
  end
end