# coding: UTF-8
ActiveAdmin.register Email do

  menu :label => "Sähköpostit ehdokkaille", :priority => 10, :if => proc { can? :manage, AdminUser }

  before_filter :add_notice
  before_filter :authorize_this

  controller do

    load_and_authorize_resource :except => :index

    def add_notice
      flash[:notice] = params[:notice] if params[:notice]
    end

    def authorize_this
      authorize! :manage, Email
    end

  end

  index do
    column :subject
    column :enqueued_at
    default_actions
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
      f.input :content, :label => "Viestin sisältö", :hint => "Jos copypastetat tekstinkäsittelyohjelmasta, varmista etteivät kappaleenvaihdot tule kahteen kertaan ja ettet käytä manuaalisia rivinvaihtoja. Viesti näyttää silloin rumalta."
      f.buttons
    end
  end

  member_action :send_mail, :method => :post do
    message = Email.find(params[:id])
    message.enqueue!

    redirect_to admin_emails_path, :notice => 'Sähköpostin lähetys ehdokkaille on nyt ajastettu. Järjestelmä lähettää viestejä itsekseen taustalla. Lähetystietoja voi tarkkailla Sendgrid-palvelussa (linkki etusivulla).'
  end

end
