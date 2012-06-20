class AdvocateUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :ssn, :email, :password, :password_confirmation, :remember_me

  has_many :electoral_alliances, :foreign_key => :primary_advocate_social_security_number, :primary_key => :ssn

#  before_validation :generate_password, :on => :create
#  before_create :encrypt_password
#  after_create :send_password

  validates_presence_of :ssn, :password, :email
  validates_uniqueness_of :email, :ssn

end
