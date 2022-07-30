class GuestUser; end

## CanCanCan aliases:
#    read: [:index, :show]
#    create: [:new, :create]
#    update: [:edit, :update]
#    destroy: [:destroy]
#    manage == full permissions
#
# https://github.com/CanCanCommunity/cancancan/blob/develop/docs/README.md
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= GuestUser.new # not signed in (yet)
    initialize_roles(user)

    # Controllers which are not provided by ActiveAdmin do not get authorized.
    # ActiveAdmin controller always authorizes, therefore access to login must
    # explicitly be granted.
    can :login, :admin
  end

  private

  # TODO: CandidateUser can edit only their own info
  def initialize_roles(user)
    case user.class.to_s
      when "AdminUser"
        admin_user_with_role(user)
      when "HakaUser"
        haka_user(user)
      when "GuestUser"
        guest_user(user)
      else
        raise "Current user class could not be determined. This is a bug."
    end
  end

  # user.role is "secretary" or "admin"
  def admin_user_with_role(user)
    send user.role, user
  end

  # user.role == "admin"
  def admin(user)
    can :access, :admin
    can :manage, :all
  end

  # user.role == "secretary"
  def secretary(user)
    can :access, :admin
    can :read, ActiveAdmin::Page, :name => "Dashboard"

    can [:read, :create, :update], Candidate

    can [:read, :create, :done], ElectoralAlliance
    can :update, ElectoralAlliance do |alliance|
      not alliance.secretarial_freeze?
    end
  end

  def guest_user(user)
  end

  def haka_user(user)
    advocate_user(user) if user.advocate_user

    can [:read], Candidate, student_number: user.student_number

    if GlobalConfiguration.candidate_nomination_period_effective?
      can [:create, :update, :cancel], Candidate, student_number: user.student_number
    end

    if GlobalConfiguration.candidate_data_correction_period?
      can [:cancel, :update], Candidate, student_number: user.student_number
      cannot [:create], Candidate
    end

    if GlobalConfiguration.candidate_data_frozen?
      cannot [:create, :update, :cancel], Candidate
    end
  end

  def advocate_user(user)
    can :access, :advocate if GlobalConfiguration.advocate_login_enabled?

    can [:read], ElectoralCoalition
    can [:read], ElectoralAlliance
    can [:read], Candidate

    if GlobalConfiguration.candidate_nomination_period_effective?
      can [:create, :update], ElectoralAlliance
      can [:create, :update], ElectoralCoalition

      can [:update], Candidate
    end

    if GlobalConfiguration.candidate_data_correction_period?
      can [:update], Candidate
      cannot [:create], ElectoralAlliance
    end

    if GlobalConfiguration.candidate_data_frozen?
      cannot [:create, :update], [ElectoralAlliance, Candidate]
    end
  end
end
