# coding: UTF-8
class Voting::VoteAmountsController < VotingController

  before_filter :assign_voting_area

  before_filter :authorize_this

  def show
  end

  def create
    @voting_area.create_votes_from(params[:votes], :use_fixed_amount => false)

    if @voting_area.errors[:invalid_candidate_numbers]
      flash[:invalid_candidate_numbers] = @voting_area.errors[:invalid_candidate_numbers]
    end

    redirect_to voting_vote_amounts_path(:anchor => 'submit-votes')
  end

  def mark_submitted
    @voting_area.submitted!

    redirect_to voting_vote_amounts_path
  end

  private

  def assign_voting_area
    @voting_area = current_voting_area_user.voting_area
  end

  def authorize_this
    authorize! :manage, :vote_amounts
  end

end
