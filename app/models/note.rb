class Note < ApplicationRecord
  belongs_to :student
  validates :added_by, presence: true
  validates :added_at, presence: true
end
