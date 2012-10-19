# coding: UTF-8

class RegistrationMailer < HyyMailer

  def welcome_advocate(email, password)
    @email = email
    @password = password
    @site_address = Vaalit::Public::ADVOCATE_LOGIN_URL

    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

  def welcome_secretary(email, password)
    @email = email
    @password = password
    @site_address = Vaalit::Public::SECRETARY_LOGIN_URL
    mail(:to => @email, :subject => 'Käyttäjätunnuksesi HYYn vaalijärjestelmään')
  end

end
