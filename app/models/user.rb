class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :vkontakte]

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def author_of?(resource)
    resource.author_id == id
  end

  def subscriber?(resource)
    Subscription.where(user: self, question: resource).any?
  end
end
