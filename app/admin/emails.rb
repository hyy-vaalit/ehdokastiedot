ActiveAdmin.register Email do

  permit_params :subject,
                :content

  menu :label => "Sähköpostit ehdokkaille", :priority => 10, :if => proc { can? :manage, AdminUser }

  before_action :add_notice

  controller do

    def add_notice
      flash[:notice] = params[:notice] if params[:notice]
    end

  end

  index do
    column :subject
    column :enqueued_at
    actions
  end

  show :title => :subject do
    attributes_table :subject do
      row("content") { raw "<pre>#{email.content}</pre>" }
      row("Lähetetty") { friendly_datetime(email.enqueued_at) }
      row("Lähetys") { button_to 'Lähetä sähköposti ehdokkaille', send_mail_admin_email_path }
    end
  end

  form do |f|
    f.inputs "Ehdokkaille lähetettävä sähköposti" do
      f.input :subject, :label => "Otsikko"
      f.input :content, :label => "Viestin sisältö", :hint => "Jos copypastetat tekstinkäsittelyohjelmasta, varmista etteivät kappaleenvaihdot tule kahteen kertaan ja ettet käytä manuaalisia rivinvaihtoja. Viesti näyttää silloin rumalta.<br/>HUOM! Viesti lähetetään vasta seuraavalta sivulta, voit turvallisesti tallentaa kirjoittamasi viestin ennen sen lähettämistä.".html_safe
      f.actions
    end
  end

  member_action :send_mail, :method => :post do
    message = Email.find(params[:id])
    message.enqueue!

    redirect_to admin_emails_path, :notice => 'Sähköpostin lähetys ehdokkaille on nyt ajastettu. Järjestelmä lähettää viestejä itsekseen taustalla. Etusivulla on linkki sähköpostien lähetystietoihin.'
  end

end
