class AdvocateUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :firstname, :lastname, :ssn, :email, :password, :password_confirmation, :remember_me,
                  :postal_address, :postal_code, :postal_city, :phone_number,
                  :electoral_alliance_ids # AdvocateUser can only be created by Admin

  has_many :electoral_alliances, :foreign_key => :primary_advocate_id

  validates_presence_of :ssn, :email, :firstname, :lastname
  validates_presence_of :password, :on => :create

  validates_uniqueness_of :email, :ssn

  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

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
