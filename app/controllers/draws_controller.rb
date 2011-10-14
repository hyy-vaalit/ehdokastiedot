# coding: UTF-8
class DrawsController < ApplicationController

  before_filter :authenticate_admin_user!
  before_filter :authorize

  layout "outside_activeadmin"

  def index
    @result = Result.freezed.first
  end

  def candidate_draws_ready
    Delayed::Job.enqueue(CandidateDrawsReadyJob.new)

    redirect_to draws_path,
                :notice => "Äänimäärien arvonnat merkitty valmiiksi.
                            Odota hetki ja lataa arvontasivu uudelleen, seuraavat arvonnat lasketaan taustalla."
  end

  def alliance_draws_ready
    Delayed::Job.enqueue(AllianceDrawsReadyJob.new)

    redirect_to draws_path,
                :notice => "Liittovertailulukujen arvonnat merkitty valmiiksi.
                            Odota hetki ja lataa arvontasivu uudelleen, seuraavat arvonnat lasketaan taustalla."
  end

  def coalition_draws_ready
    Delayed::Job::enqueue(CoalitionDrawsReadyJob.new)

    redirect_to draws_path,
                :notice => "Rengasvertailulukujen arvonnat merkitty valmiiksi.
                            Odota hetki ja lataa arvontasivu uudelleen, lopullinen vaalitulos lasketaan taustalla."
  end


  protected

  def authorize
    authorize! :manage, :draws
  end

end
