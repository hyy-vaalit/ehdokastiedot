class AdvocateUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :firstname, :lastname, :ssn, :email, :password, :password_confirmation, :remember_me,
                  :postal_address, :postal_code, :postal_city, :phone_number

  has_many :electoral_alliances, :foreign_key => :primary_advocate_id

#  before_validation :generate_password, :on => :create
#  before_create :encrypt_password
#  after_create :send_password

  validates_presence_of :ssn, :password, :email
  validates_uniqueness_of :email, :ssn

  before_validation :generate_password, :on => :create
  after_create      :send_password

  def friendly_name
    "#{firstname} #{lastname}"
  end


  protected

  def generate_password
    self.password = Devise.friendly_token.first(6)
  end

  def send_password
    RegistrationMailer.welcome_advocate(email,password).deliver
  end
end
