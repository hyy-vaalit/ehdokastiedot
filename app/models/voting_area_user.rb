class VotingAreaUser < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :validatable

  belongs_to :voting_area
end
