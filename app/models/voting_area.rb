class VotingArea < ActiveRecord::Base

  attr_accessor :password

  validates_presence_of :password

  before_save :encrypt_password

  private

  def encrypt_password
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

end
