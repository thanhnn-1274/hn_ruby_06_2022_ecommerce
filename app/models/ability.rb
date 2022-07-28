class Ability
  include CanCan::Ability

  def initialize user
    can %i(read sort), Book
    can :read, Category

    if user&.admin?
      can :manage, :all
    elsif user&.customer?
      can %i(create read sort), Order, user_id: user.id
      can :update, Order, user_id: user.id, status: :pending
      can :manage, User, id: user.id, role: :customer
      cannot :destroy, User, id: user.id, role: :customer
      can :manage, :cart
    end
  end
end
