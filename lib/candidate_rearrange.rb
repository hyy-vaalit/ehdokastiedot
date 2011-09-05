module CandidateRearrange

  def switch_proportionals_according_draws
    CandidateDraw.all.each do |draw|
      drawings = draw.candidate_drawings.rank(:position_in_draw)
      values = []
      draw.candidates.selection_order.each do |candidate|
        values << {:lvert => candidate.fixed_alliance_proportional, :rvert => candidate.fixed_coalition_proportional}
      end
      drawings.each do |drawing|
        data = values.shift
        drawing.candidate.update_attribute :fixed_alliance_proportional, data[:lvert]
        drawing.candidate.update_attribute :fixed_coalition_proportional, data[:rvert]
      end
    end
  end

end
