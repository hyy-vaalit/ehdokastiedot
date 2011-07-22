class AdminUser < ActiveRecord::Base

  ROLES = %w[admin secretary advocate]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :role, :password, :password_confirmation, :remember_me

  before_validation :generate_password, :on => :create

  belongs_to :electoral_alliance

  #def candidates
  #  if role == 'admin'
  #    Candidate.all
  #  else
  #    self.electoral_alliance.candidates
  #  end
  #end

  private

  def generate_password
    self.password = Passgen::generate unless self.password
  end

end
