class Registrations::CandidatesController < RegistrationsController
  before_action :set_invite_code
  before_action :find_alliance, except: [:index]

  def index
  end

  def edit
  end

  # TODO: authorize only own student number
  def show
    @candidate = Candidate.find_by(student_number: params[:student_number])
  end

  def new
    # todo: prefill candidate info from session
    # todo: onko tiedekunta pakollinen
    @candidate = Candidate.new(
      electoral_alliance: @alliance,
      lastname: "Sukuniminen",
      firstname: "Esi Täytetty",
      candidate_name: "Sukunimi, Esi",
      email: "esi.taytetty@helsinki.fi",
      student_number: "0123456" # TODO
    )
    @advocate_user = @alliance.advocate_user if @alliance

    if @alliance.nil?
      flash[:alert] = "Kutsukoodi \"#{@invite_code_upcase}\" ei ole voimassa."
      redirect_to registrations_candidates_path
    end
  end

  # Create candidate based on values submitted in the form, except
  # - read student_number from the session so that one can only use student number of their own
  # - find alliance by invite_code so one can only apply to an alliance they have been invited to
  def create
    @candidate = Candidate.new(
      student_number: "0123456", # sensitive - don't read from params
      electoral_alliance: @alliance, # sensitive - don't read from params
      candidate_name: params["candidate"]["candidate_name"],
      email: params["candidate"]["email"],
      lastname: params["candidate"]["lastname"],
      firstname: params["candidate"]["firstname"],
    )

    if @candidate.save
      flash[:notice] = "Ehdokasilmoittautuminen vastaanotettu!"
      redirect_to registrations_candidate_path(@candidate.student_number)
    else
      flash[:error] = "Ehdokasilmoittautuminen ei onnistunut, koska lomakkeen tiedoissa oli virheitä."
      render :new
    end

  end

  protected

  def set_invite_code
    @invite_code_upcase = params[:invite_code]&.upcase&.strip
  end

  def find_alliance
    @alliance = ElectoralAlliance.find_by(invite_code: @invite_code_upcase)
  end
end
