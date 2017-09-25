class Submission < ApplicationRecord
  belongs_to :user, inverse_of: :submissions

  enum status: [:pending, :rejected, :accepted]

  scope :needs_sorting, -> { where(status: 0) }
end
