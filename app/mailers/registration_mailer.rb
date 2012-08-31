# coding: UTF-8

class RegistrationMailer < HyyMailer

  def new_password(password, email)
    @email = email
    @password = password
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

  def welcome_advocate(email, password)
    @email = email
    @password = password
    @site_address = Vaalit::Public::ADVOCATE_LOGIN_URL

    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

  def secretary(password, email)
    @email = email
    @password = password
    @site_address = Vaalit::Public::SECRETARY_LOGIN_URL
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

end
