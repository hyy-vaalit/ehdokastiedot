class VotingArea < ActiveRecord::Base

  attr_accessor :password

  validates_presence_of :password

  before_save :encrypt_password

  def self.authenticate code, password
    area = self.find_by_code code
    return nil if area.nil?
    return area if area.has_password? password
  end

  def has_password? password
    self.encrypted_password == encrypt(password)
  end

  private

  def encrypt_password
    self.encrypted_password = encrypt password
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

end
