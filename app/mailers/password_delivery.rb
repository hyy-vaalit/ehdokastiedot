# coding: UTF-8

class PasswordDelivery < HyyMailer

  def new_password(password, email)
    @email = email
    @password = password
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

  def advocate_creator(password, email, alliance_name)
    @email = email
    @password = password
    @site_address = 'http://vaalit.hyy.fi/admin'
    @alliance_name = alliance_name
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

  def advocate_fixer(password, email, alliance_name)
    @email = email
    @password = password
    @site_address = 'http://vaalit.hyy.fi/advocate'
    @alliance_name = alliance_name
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

  def secretary(password, email)
    @email = email
    @password = password
    @site_address = 'http://vaalit.hyy.fi/admin'
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

end
