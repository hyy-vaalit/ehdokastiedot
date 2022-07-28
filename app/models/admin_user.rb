class AdminUser < ActiveRecord::Base
  include DeviseUserBehaviour

  enum role: {
    "admin" => "admin",
    "secretary" => "secretary"
  }

  # Devise modules
  # https://www.rubydoc.info/github/plataformatec/devise/Devise/Models
  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable,
    :trackable, :validatable

  scope :secretaries, -> { where(:role => "secretary") }

  validates :role,
    presence: true,
    inclusion: { in: self.roles.keys }

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
