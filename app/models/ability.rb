class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :admin

    user ||= AdminUser.new # guest user (not logged in)
    send user.role if user.role
  end

  def admin
    can :manage, :all
  end

  def secretary
  end

  def advocate
  end

end
