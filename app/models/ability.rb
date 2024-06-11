# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end


  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], author_id: user.id 
    can :best, Answer, question: { author_id: user.id }

    can :update, Comment, user_id: user.id
    can :manage, Like
    cannot :manage, Like, likeable: { author_id: user.id }, user_id: user.id
    can :destroy, Link, linkable: { author_id:  user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :me, User, id: user.id
    can :answers, Question
  end
end
