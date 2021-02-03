class DrawsController < ApplicationController

  before_action :authenticate_admin_user!
  before_action :authorize

  def index
    @result = Result.freezed.first
  end

  def candidate_draws_ready
    enqueue(CandidateDrawsReadyJob.new)

    redirect_to draws_path,
                :notice => "Äänimäärien arvonnat merkitty valmiiksi.
                            Odota hetki ja lataa arvontasivu uudelleen, seuraavat arvonnat lasketaan taustalla."
  end

  def alliance_draws_ready
    enqueue(AllianceDrawsReadyJob.new)

    redirect_to draws_path,
                :notice => "Liittovertailulukujen arvonnat merkitty valmiiksi.
                            Odota hetki ja lataa arvontasivu uudelleen, seuraavat arvonnat lasketaan taustalla."
  end

  def coalition_draws_ready
    enqueue(CreateFinalResultJob.new)

    redirect_to draws_path,
                :notice => "Rengasvertailulukujen arvonnat merkitty valmiiksi.
                            Odota hetki ja lataa arvontasivu uudelleen, lopullinen vaalitulos lasketaan taustalla."
  end


  protected

  def enqueue(job)
    Result.freezed.first.in_process!
    Delayed::Job::enqueue(job)
  end

  def authorize
    authorize! :manage, :draws
  end

  def automatically?
    params[:automatically] == "true"
  end
end
