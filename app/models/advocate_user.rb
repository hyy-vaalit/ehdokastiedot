class AdvocateUser < ActiveRecord::Base
  include DeviseUserBehaviour

  # Devise modules
  # https://www.rubydoc.info/github/plataformatec/devise/Devise/Models
  devise :database_authenticatable, :timeoutable, :recoverable, :trackable, :validatable

  has_many :electoral_alliances, :foreign_key => :primary_advocate_id

  validates_presence_of :student_number, :email, :firstname, :lastname

  validates_uniqueness_of :email, :student_number
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  def friendly_name
    "#{firstname} #{lastname}"
  end

  protected

  def send_password
    RegistrationMailer.welcome_advocate(email, password).deliver
  end
end
