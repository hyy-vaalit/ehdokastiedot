class AdminUser < ActiveRecord::Base
  include DeviseUserBehaviour

  enum :role, {
    "admin" => "admin"
  }

  # Devise modules
  # https://www.rubydoc.info/github/plataformatec/devise/Devise/Models
  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable,
    :trackable, :validatable

  validates :role,
    presence: true,
    inclusion: { in: self.roles.keys }

  # Attributes searchable in ActiveAdmin (exclude sensitive fields)
  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      current_sign_in_at
      current_sign_in_ip
      email
      id
      id_value
      last_sign_in_at
      last_sign_in_ip
      role
      sign_in_count
      updated_at
    ]
  end

  def is_admin?
    role == 'admin'
  end

  private

  # The welcome_secretary name is a historical relic from the removed
  # secretary role; the mail is sent to every admin user.
  def send_password
    RegistrationMailer.welcome_secretary(email, password).deliver_now
  end
end
