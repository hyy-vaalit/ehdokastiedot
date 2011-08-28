class PasswordDelivery < HyyMailer

  def new_password(password, email)
    @email = email
    @password = password
    mail(:to => @email, :subject => 'HYY-vaalit password')
  end

  def advocate_creator(password, email, alliance_name)
    @email = email
    @password = password
    @site_address = 'http://vaalit.hyy.fi'
    @alliance_name = alliance_name
    mail(:to => @email, :subject => 'HYY-vaalit password')
  end

  def advocate_fixer(password, email, alliance_name)
    @email = email
    @password = password
    @site_address = 'http://vaalit.hyy.fi'
    @alliance_name = alliance_name
    mail(:to => @email, :subject => 'HYY-vaalit password')
  end

  def secretary(password, email)
    @email = email
    @password = password
    @site_address = 'http://vaalit.hyy.fi'
    mail(:to => @email, :subject => 'HYY-vaalit password')
  end

end
