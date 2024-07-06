class Answer < ApplicationRecord
  include Linkable
  include Likeable
  include Commentable

  has_many_attached :files

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true, length: { minimum: 3 }

  after_create :send_email

  private

  def send_email
    NotifyNewAnswerJob.perform_later(self)
  end
end
