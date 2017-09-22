class Submission < ApplicationRecord
  belongs_to :user, inverse_of: :submissions
end
