class CoalitionResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :electoral_coalition
end
