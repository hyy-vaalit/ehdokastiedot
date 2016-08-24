module DeviseUserBehaviour
  extend ActiveSupport::Concern

  included do
    # Generate a password only if it was not set manually (when password_confirmation is present)
    before_validation :generate_password, :on => :create, :if => "password_confirmation.nil?"

    validates_presence_of :password, :on => :create
    after_create :send_password

    protected

    def generate_password
      self.password = Devise.friendly_token.first(8)
    end

    def send_password
      raise "plz implement"
    end

  end

end
