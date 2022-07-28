class AdvocatesController < ApplicationController
  before_action :require_advocate_user
  before_action :authorize_this!

  def index
  end

  protected

  def authorize_this!
    authorize! :access, :advocate
  end

  def require_advocate_user
    unless current_advocate_user.present?
      flash.alert = <<-MSG.squish
        Käyttäjätunnuksellasi ei ole vaaliliiton edustajan oikeuksia.
        Tarvittaessa pyydä oikeudet HYYn vaalityöntekijältä.
      MSG

      redirect_to registrations_root_path and return
    end
  end
end
