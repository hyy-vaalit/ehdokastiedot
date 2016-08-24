class AdminUser < ActiveRecord::Base
  include DeviseUserBehaviour

  ROLES = %w[admin secretary]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :secretaries, -> { where(:role => "secretary") }

  validates_presence_of :role

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
