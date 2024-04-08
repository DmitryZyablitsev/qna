class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  validates :state, presence: true, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: [:likeable_id, :likeable_type] }
end
