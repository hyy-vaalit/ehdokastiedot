class AdvocateUser < ActiveRecord::Base
  include DeviseUserBehaviour

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable

  has_many :electoral_alliances, :foreign_key => :primary_advocate_id

  validates_presence_of :ssn, :email, :firstname, :lastname

  validates_uniqueness_of :email, :ssn
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  def friendly_name
    "#{firstname} #{lastname}"
  end


  protected

  def send_password
    RegistrationMailer.welcome_advocate(email, password).deliver
  end

end
