class Registrations::CandidatesController < RegistrationsController
  before_action :require_student_number
  before_action :set_invite_code
  before_action :set_candidate

  def edit; end

  def show
    @cancelled_candidates = Candidate.cancelled.where(student_number: session[:student_number])
  end

  def update
    if @candidate.update(candidate_params)
      flash.notice = "Tiedot päivitettiin onnistuneesti!"
      redirect_to registrations_candidate_path
    else
      flash.alert = "Tietojen päivittämisessä meni jotain vikaan."
      render :edit
    end
  end

  def cancel
    if @candidate.cancel!
      flash.notice = "Ehdokkuutesi edustajistovaaleissa on peruttu."
    else
      flash.error = "Ehdokkuuden peruminen ei onnistunut. Ota yhteys HYYn vaalityöntekijään."
    end

    redirect_to registrations_candidate_path
  end

  def new
    session[:student_number] = "0123456" # TODO: Change after auth

    if @candidate.present?
      flash[:notice] = "Opiskelijanumerollasi on voimassa oleva ehdokasilmoittautuminen."
      redirect_to registrations_candidate_path and return
    end

    @alliance = find_alliance

    # todo: prefill candidate info from session
    @candidate = Candidate.new(
      electoral_alliance: @alliance,
      lastname: "Sukuniminen",
      firstname: "Esi Täytetty",
      candidate_name: "Sukunimi, Esi",
      email: "esi.taytetty@helsinki.fi",
      student_number: session[:student_number]
    )
    @advocate_user = @alliance.advocate_user if @alliance

    if @alliance.nil?
      if @invite_code_upcase.blank?
        flash[:alert] = "Pyydä vaaliliiton edustajalta kutsukoodi, jotta voit rekisteröityä vaaliliiton ehdokkaaksi."
      else
        flash[:alert] = "Kutsukoodi \"#{@invite_code_upcase}\" ei ole voimassa."
      end
      redirect_to root_path and return
    end
  end

  # Create candidate based on values submitted in the form, except
  # - read student_number from the session so that one can only use student number of their own
  # - find alliance by invite_code so one can only apply to an alliance they have been invited to
  def create
    @alliance = find_alliance
    @candidate = Candidate.new(candidate_params).tap do |t|
      t.student_number = session[:student_number] # sensitive
      t.electoral_alliance = @alliance # sensitive
    end

    if @candidate.save
      flash.notice = "Ehdokasilmoittautuminen vastaanotettu!"
      redirect_to registrations_candidate_path(@candidate.student_number)
    else
      flash.alert = "Ehdokasilmoittautuminen ei onnistunut, koska lomakkeen tiedoissa oli virheitä."
      render :new
    end
  end

  protected

  def require_student_number
    # TODO: change once auth is implemented
    if session[:student_number].blank?
      render plain: "TOOD: require student nubmer", status: 401
    end
  end

  def set_invite_code
    @invite_code_upcase = params[:invite_code]&.upcase&.strip
  end

  def set_candidate
    @candidate = Candidate.valid.find_by(student_number: session[:student_number])
  end

  def find_alliance
    ElectoralAlliance.find_by(invite_code: @invite_code_upcase)
  end

  def candidate_params
    params.require(:candidate).permit(
      :lastname,
      :firstname,
      :candidate_name,
      :faculty_id,
      :address,
      :postal_code,
      :postal_city,
      :phone_number,
      :email,
      :notes
    )
  end
end
