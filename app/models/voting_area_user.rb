class VotingAreaUser < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :voting_area

  belongs_to :voting_area
end
