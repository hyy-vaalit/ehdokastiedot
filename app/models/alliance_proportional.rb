class AllianceProportional < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate

  def self.calculate!
    raise "unfinished"
  end

end
