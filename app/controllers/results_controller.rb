# coding: UTF-8
class ResultsController < ApplicationController

  skip_authorization_check

  def index
    respond_to do |format|
      format.html { redirect_to REDIS.get('tulos-alustava.html') }
      format.text { redirect_to REDIS.get('tulos-alustava.txt') }
    end
  end

  def final
    respond_to do |format|
      format.html { redirect_to REDIS.get('tulos-lopullinen.html') }
      format.text { redirect_to REDIS.get('tulos-lopullinen.txt') }
    end
  end

  def deputies
    @candidates = Candidate.selected.selection_order.all
  end

  def by_votes
    @candidates = Candidate.all.sort{|x,y| y.total_votes <=> x.total_votes} #TODO: improve with SQL
  end

  def by_alliance
    @coalitions = ElectoralCoalition.all
  end

end
