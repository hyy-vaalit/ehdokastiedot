class AdminUser < ActiveRecord::Base

  ROLES = %w[admin secretary]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :role, :password, :password_confirmation, :remember_me

  scope :secretaries, where(:role => "secretary")

  validates_presence_of :role

  before_validation :generate_password, :on => :create

  after_create :send_password

  belongs_to :electoral_alliance


  def is_secretary?
    role == 'secretary'
  end

  def is_admin?
    role == 'admin'
  end

  private

  def generate_password
    self.password = Passgen::generate unless self.password
  end

  def send_password
    if role == 'secretary' # FIXME: use method!
      RegistrationMailer.secretary(password, email).deliver
    else
      RegistrationMailer.new_password(password, email).deliver
    end
  end

end
