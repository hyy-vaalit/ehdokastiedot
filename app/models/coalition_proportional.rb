class CoalitionProportional < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate

  def self.calculate!

    # ota liiton kaikki ehdokkaat
    # järjestettynä liittovertailuluvun mukaan
    # jokaiselle ehdokkaalle e,
    # anna koko liiton saamat äänet jaettuna iteraatiokierroken järjestysnumerolla. /1, /2,..,/n

  end
end
