module Likeable
  extend ActiveSupport::Concern
  included do
    has_many :likes, dependent: :destroy, as: :likeable
  end

  def raiting
    self.likes.sum(:state)
  end
end
