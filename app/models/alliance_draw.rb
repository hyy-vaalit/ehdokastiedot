class AllianceDraw < ActiveRecord::Base
  has_many :candidate_results, :dependent => :nullify
  belongs_to :result
  @@identifier_range = ('a'..'zzz').to_a

  def identifier_number=(number)
    self.identifier = @@identifier_range[number]
  end

end
