class AdvocatesController < ApplicationController

  before_filter :authenticate_advocate_user!

  skip_authorization_check # FIXME

  def index
  end

end
