class AdvocateUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :firstname, :lastname, :ssn, :email, :password, :password_confirmation, :remember_me,
                  :postal_address, :postal_code, :postal_city, :phone_number

  has_many :electoral_alliances, :foreign_key => :primary_advocate_id

#  before_validation :generate_password, :on => :create
#  before_create :encrypt_password
#  after_create :send_password

  validates_presence_of :ssn, :password, :email
  validates_uniqueness_of :email, :ssn

  def friendly_name
    "#{firstname} #{lastname}"
  end
end
