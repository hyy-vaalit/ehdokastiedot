class PasswordDelivery < HyyMailer

  def new_password(password, email)
    @email = email
    @password = password
    mail(:to => @email, :subject => 'HYY-vaalit password')
  end

end
