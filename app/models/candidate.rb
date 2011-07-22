class Candidate < ActiveRecord::Base
  include RankedModel

  belongs_to :electoral_alliance
  ranks :sign_up_order, :with_same => :electoral_alliance_id

  belongs_to :faculty

  has_many :data_fixes

  def cancel!
    self.update_attribute :cancelled, true
  end

end
