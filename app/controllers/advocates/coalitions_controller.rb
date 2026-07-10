class Advocates::CoalitionsController < AdvocatesController
  before_action :set_advocate_team
  before_action :set_coalition

  def update
    authorize! :update, ElectoralCoalition, electoral_coalition_id: @coalition&.id
    if @advocate_team.nil?
      flash.alert = t(".team_needed")
      redirect_to advocates_alliances_path and return
    end

    if @coalition.nil?
      flash.alert = t(".coalition_not_found")
      redirect_to advocates_alliances_path and return
    end

    alliance = current_advocate_user.electoral_alliances.find(params[:electoral_alliance_id])

    if @coalition.electoral_alliances << alliance
      flash.notice = t(".linked", alliance: alliance.shorten, coalition: @coalition.shorten)
    else
      flash.alert = t(".link_failed")
    end

    redirect_to advocates_alliances_path
  rescue ActiveRecord::RecordNotFound
    flash.alert = t(".not_found")
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
