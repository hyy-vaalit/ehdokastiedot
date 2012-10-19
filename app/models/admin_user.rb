class AdminUser < ActiveRecord::Base
  include DeviseUserBehaviour

  ROLES = %w[admin secretary]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :role, :password, :password_confirmation, :remember_me

  scope :secretaries, where(:role => "secretary")

  validates_presence_of :role

  belongs_to :electoral_alliance

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
