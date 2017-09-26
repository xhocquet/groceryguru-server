require 'test_helper'

class Admin::SubmissionControllerTest < ActionDispatch::IntegrationTest
  test "should validate submission and create record" do
    sign_in users(:admin)
    @submission = submissions(:pending)
    assert_difference "::Item::Mode.all.size", 1 do
      post admin_submission_validate_path(submission_id: @submission.id), params: { submission: { name: 'alamode' } }
    end
    assert_equal ::Item::Mode.last.name, 'alamode'
    assert_redirected_to admin_items_submissions_path
  end

  test "should reject submission" do
    sign_in users(:admin)
    @submission = submissions(:pending)
    delete admin_submission_path(@submission)
    assert_redirected_to admin_items_submissions_path
  end

  test "cannot destroy submission without admin" do
    @submission = submissions(:pending)
    delete admin_submission_path(@submission)
    assert_redirected_to new_user_session_path
  end
end