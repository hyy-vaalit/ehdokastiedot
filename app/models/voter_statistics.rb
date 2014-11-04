class VoterStatistics

  def self.by_voting_area
    view_context.render :template => "manage/voters/by_voting_area.json"
  end

  def self.by_gender
    view_context.render :template => "manage/voters/by_gender.json"
  end

  private

  def self.view_context
    ApplicationController.view_context_class.new(Rails.configuration.paths['app/views'])
  end
end
