class PublicController < ApplicationController
  skip_authorization_check

  def index
  end

  def unauthorized
  end
end
