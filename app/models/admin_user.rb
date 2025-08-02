class AdminUser < ActiveRecord::Base
  include DeviseUserBehaviour

  enum(role: { "admin" => "admin", "secretary" => "secretary" })

  # Devise modules
  # https://www.rubydoc.info/github/plataformatec/devise/Devise/Models
  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable,
    :trackable, :validatable

  scope :secretaries, -> { where(:role => "secretary") }

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

  def is_secretary?
    role == 'secretary'
  end

  def is_admin?
    role == 'admin'
  end

  private

  def send_password
    RegistrationMailer.welcome_secretary(email, password).deliver
  end
end
