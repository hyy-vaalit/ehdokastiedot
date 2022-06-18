class Registrations::CandidatesController < RegistrationsController
  before_action :set_invite_code
  before_action :find_alliance, only: [:new]

  def show
  end

  def new
    invite_code = @invite_code_upcase

    if invite_code.present? && @alliance.nil?
      flash[:alert] = "Kutsukoodi \"#{invite_code}\" ei ole voimassa."
    end
  end

  protected

  def set_invite_code
    @invite_code_upcase = params[:invite_code].upcase.strip
  end

  def find_alliance
    alliance_invite_code = @invite_code_upcase

    @alliance = ElectoralAlliance.find_by(invite_code: alliance_invite_code)
  end
end
