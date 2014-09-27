class Voting::VotersController < VotingController
  def index
  end

  def search
    render :text => "haku toimii #{params.inspect}"
  end
end
