# encoding: utf-8
class Advocates::CandidatesController < AdvocatesController

  before_filter :find_alliance

  def new
    @candidate = Candidate.new(:electoral_alliance => @alliance)
  end

  def create
    @candidate = @alliance.candidates.build(params[:candidate])
    if @candidate.save
      flash[:notice] = "Ehdokas luotu!"
      redirect_to advocates_alliance_path(@alliance)
    else
      flash[:alert] = "Ehdokkaan luominen epäonnistui."
      render :action => :new
    end
  end

  protected

  def find_alliance
    @alliance = current_advocate_user.electoral_alliances.find(params[:alliance_id])
  end

end
