class AdvocateUser < ActiveRecord::Base

  has_many :electoral_alliances, :foreign_key => :primary_advocate_social_security_number, :primary_key => :ssn

  before_validation :generate_password, :on => :create

  before_create :encrypt_password

  after_create :send_password

  attr_accessor :password

  validates_presence_of :ssn, :password

  def self.authenticate email, password
    advocate = self.find_by_email email
    return nil unless advocate
    return advocate if advocate.has_password? password
  end

  def has_password? password
    self.encrypted_password == encrypt(password)
  end

  private

  def generate_password
    self.password = Passgen::generate unless self.password
  end

  def encrypt_password
    self.encrypted_password = encrypt password
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

  def send_password
    PasswordDelivery.advocate_fixer(self.password, self.email, self.electoral_alliances.first.name).deliver
  end

end
