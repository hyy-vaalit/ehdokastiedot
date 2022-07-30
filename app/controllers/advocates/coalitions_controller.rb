class Advocates::CoalitionsController < AdvocatesController
  before_action :set_advocate_team
  before_action :set_coalition

  def update
    authorize! :update, ElectoralCoalition, electoral_coalition_id: @coalition&.id
    if @advocate_team.nil?
      flash.alert = "Tarvitset ensin edustajatiimin voidaksesi liittää vaaliliiton vaalirenkaaseen."
      redirect_to advocates_alliances_path and return
    end

    if @coalition.nil?
      flash.alert = "Pyydettyä vaalirengasta ei löydy."
      redirect_to advocates_alliances_path and return
    end

    alliance = current_advocate_user.electoral_alliances.find(params[:electoral_alliance_id])

    if @coalition.electoral_alliances << alliance
      flash.notice = <<-MSG
        Vaaliliitto "#{alliance.shorten}" kytkettiin renkaaseen "#{@coalition.shorten}".
      MSG
    else
      flash.alert = "Vaaliliiton kytkeminen vaalirenkaaseen epäonnistui"
    end

    redirect_to advocates_alliances_path
  rescue ActiveRecord::RecordNotFound
    flash.alert = "Odottamaton virhe, pyydettyä tietoa ei löytynyt tai pääsy kielletty."
    redirect_to advocates_alliances_path
  end

  protected

  def set_advocate_team
    @advocate_team = current_advocate_user&.advocate_team
  end

  def set_coalition
    @coalition = current_advocate_user&.advocate_team&.electoral_coalition
  end
end
