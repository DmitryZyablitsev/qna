class Question < ApplicationRecord
  include Linkable
  include Likeable

  has_many :answers, dependent: :destroy  
  has_many_attached :files
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true
end
