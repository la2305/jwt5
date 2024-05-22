# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super_admin?
      can :manage, :all
    elsif user.admin? || user.user?
      can [:read, :create, :update], :all
    end
  end
end
