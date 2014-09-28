class Voting::VotersController < VotingController
  def index
  end

  def edit
    @voter = Voter.find params[:id]
  end

  def search
    @voters = Voter.matching_name params[:name]
  end

  def mark_voted
    @voter = Voter.find params[:voter_id]

    if @voter.mark_voted!(current_user.voting_area)
      flash[:notice] = "Henkilö '#{@voter.name}' merkitty äänestäneeksi."
      redirect_to voting_voters_path
    else
      flash[:alert] = "Kirjaus epäonnistui! Henkilö äänestänyt alueella #{@voter.voting_area.name} klo #{@voter.voted_at.localtime}"
      redirect_to edit_voting_voter_path(@voter)
    end
  end
end
