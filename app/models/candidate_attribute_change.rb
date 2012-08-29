class CandidateAttributeChange < ActiveRecord::Base

  def self.create_from!(candidate_id, changed_attributes)
    changed_attributes.each do |key, values|
      self.create!(:attribute_name => key,
                   :previous_value => values.first.to_s,
                   :new_value      => values.last.to_s,
                   :candidate_id   => candidate_id).inspect
    end

    true
  end
end
