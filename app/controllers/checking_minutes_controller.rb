# coding: UTF-8
class CheckingMinutesController < ApplicationController

  # FIXME: Käsittämätön autentikaatiologiikka ja kaksi eri tyyppistä käyttäjää.
  #        Kamala toteutus ja suuri riski siihen että oikeudet ovat väärin.


  skip_authorization_check :except => :summary # accessible by tlk-pj

  before_action :authenticate, :except => [:summary, :ready] # accessible by admin user
  before_action :check_if_ready, :except => [:fixes, :summary, :ready]

  def index
    @voting_areas = VotingArea.by_code
  end

  def show
    @voting_area = VotingArea.find(params[:id])
  end

  def edit
    @voting_area = VotingArea.find(params[:id])
  end

  def update
    @voting_area = VotingArea.find(params[:id])
    @voting_area.create_votes_from(params[:votes], :use_fixed_amount => true)

    flash[:invalid_candidate_numbers] = @voting_area.errors[:invalid_candidate_numbers] if @voting_area.errors[:invalid_candidate_numbers]

    redirect_to edit_checking_minute_path(@voting_area.id, :anchor => 'vote_fix_form'), :notice => "Korjatut äänimäärät talletettu."
  end

  # FIXME: Brainfuck. fixes vs. summary
  def fixes
    @voting_areas = VotingArea.by_code
  end

  # FIXME: Brainfuck. fixes vs. summary
  def summary
    authorize! :manage, VotingArea
    @voting_areas = VotingArea.by_code
    render :fixes
  end

  def ready
    Delayed::Job.enqueue(CreateFreezedResultJob.new)
    redirect_to draws_path, :notice => "Tarkastuslaskenta on merkitty valmiiksi!"
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      CheckingMinutesUser.authenticate username, password
    end
  end

  def check_if_ready
    if Result.freezed.any?
      redirect_to fixes_checking_minutes_path, :notice => 'Tarkastuslaskenta on merkitty valmiiksi eikä korjauksia voi enää syöttää.'
      return
    end
  end

end
