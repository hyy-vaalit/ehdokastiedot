# coding: UTF-8
ActiveAdmin.register Email do

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

  show :title => :subject do
    attributes_table :subject, :content
    link_to 'Lähetä sähköposti', send_mail_admin_email_path, :class => 'button'
  end

  member_action :send_mail do
    email = Email.find_by_id(params[:id])
    addresses = Candidate.all.map(&:email)

    CandidateNotifier.welcome_as_candidate(addresses, email).deliver

    redirect_to admin_email_path(email.id), :notice => 'Sähköposti lähetetty onnistuneesti'
  end

end
