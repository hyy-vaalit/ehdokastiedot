module DeviseUserBehaviour
  extend ActiveSupport::Concern

  included do
    before_validation :generate_password, :on => :create

    validates_presence_of :password, :on => :create
    after_create :send_password

    protected

    # Generate a password only if it was not set manually (when password_confirmation is present)
    def generate_password
      if password_confirmation.nil?
        self.password = Devise.friendly_token.first(8)
      end
    end

    def send_password
      raise "plz implement"
    end

  end

end
