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
    default_actions
  end

  show :title => :subject do
    attributes_table :subject do
      row("content") { raw "<pre>#{email.content}</pre>" }
    end
    link_to 'Lähetä sähköposti ehdokkaille', send_mail_admin_email_path, :class => 'button'
  end

  member_action :send_mail do
    raise "THIS IS BORKEN:/ timeout error. and some weird heroku+sendgrid issue which prevents email sending from rails console."

    message = Email.find_by_id(params[:id])
    Candidate.all.each do |c|
      CandidateNotifier.welcome_as_candidate(c.email, message).deliver # FIXME
    end

    redirect_to admin_email_path(email.id), :notice => 'Sähköposti lähetetty! Lähetystietoja voi tarkkailla Sendgrid-palvelussa.'
  end

end
