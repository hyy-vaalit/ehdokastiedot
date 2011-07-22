ActiveAdmin.register Email do

  before_filter :add_notice

  controller do

    load_and_authorize_resource :except => :index

    def add_notice
      flash[:notice] = params[:notice] if params[:notice]
    end

  end

  action_item :only => :show do
    link_to 'Send', send_mail_admin_email_path
  end

  member_action :send_mail do
    email = Email.find_by_id(params[:id])
    addresses = Candidate.all.map(&:email)

    CandidateNotifier.welcome_as_candidate(addresses, email).deliver

    redirect_to :action => :show, :notice => 'emails sent'
  end

end
