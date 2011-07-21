class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :admin

    user ||= AdminUser.new # guest user (not logged in)
    send user.role, user if user.role
  end

  def admin user
    can :manage, :all
    cannot :report_fixes, Candidate
  end

  def secretary user
    unless user.electoral_alliance.nil? or user.electoral_alliance.secretarial_freeze
      can [:read, :update], Candidate, :electoral_alliance_id => user.electoral_alliance_id
      can :create, Candidate

      can [:read, :update, :done], ElectoralAlliance, :id => user.electoral_alliance_id
    end
    can :create, ElectoralAlliance
  end

  def advocate user
    unless user.electoral_alliance.nil? or user.electoral_alliance.secretarial_freeze
      can [:read, :report_fixes], Candidate, :electoral_alliance_id => user.electoral_alliance_id
    end
  end

end
