class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdvocateUser.new # guest user (not logged in)
    initialize_roles(user)
  end

  def admin(user)
    can :access, :admin
    can :manage, :all
  end

  def secretary(user)
    can :access, :admin

    can [:read, :new, :create, :update, :create], Candidate
    can [:read, :new, :create, :update, :done], ElectoralAlliance
  end

  def advocate(user)
    can :access, :advocate if GlobalConfiguration.advocate_login_enabled?

    can [:manage, :index, :new, :show, :edit, :update, :create, :destroy], [ElectoralAlliance, Candidate]

    if not GlobalConfiguration.candidate_nomination_period_effective?
      cannot [:create, :new, :update, :destroy], ElectoralAlliance
      cannot [:create, :new, :destroy], Candidate
    end

    if GlobalConfiguration.candidate_data_frozen?
      cannot [:create, :new, :update, :destroy, :edit], [ElectoralAlliance, Candidate]
    end
  end


  private

  def initialize_roles(user)
    case user.class.to_s when "AdminUser"
      initialize_admin(user)
    when "AdvocateUser"
      initialize_advocate(user)
    else
      raise "Current user class could not be determined. This is a bug."
    end
  end

  def initialize_admin(user)
    send user.role, user
  end

  def initialize_advocate(user)
    send :advocate, user
  end
end
