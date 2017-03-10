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

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, Attachment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :comment, [Question, Answer]

    can :best_answer, Question, user: user
    can :update_body, Question, user: user

    can :upvote, [Question, Answer] do |votable|
      votable.user != user
    end

    can :downvote, [Question, Answer] do |votable|
      votable.user != user
    end

    can :destroy, Attachment do |attachment|
      attachment.attachable.user == user
    end

    can :create, Vote do |vote|
      vote.votable.user != user
    end

    can :update, Vote do |vote|
      vote.votable.user != user
    end

    can :destroy, Vote do |vote|
      vote.votable.user == user
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
