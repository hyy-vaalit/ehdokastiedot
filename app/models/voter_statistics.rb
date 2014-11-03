class VoterStatistics

  def self.by_voting_area
    view = ApplicationController.view_context_class.new(Rails.configuration.paths['app/views'])

    view.render :template => "manage/voters/by_voting_area.json" # , :locals => {:result => self}
  end

end
