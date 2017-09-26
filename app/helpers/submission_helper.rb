module SubmissionHelper
  def submission_status_icon(type)
    if Submission.where(model_type: type).needs_sorting.count > 0
      content_tag :i, 'warning', class: 'material-icons has-text-danger'
    else
      content_tag :i, 'check_circle', class: 'material-icons has-text-success'
    end
  end
end