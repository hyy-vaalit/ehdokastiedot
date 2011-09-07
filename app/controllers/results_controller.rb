# coding: UTF-8
class ResultsController < ApplicationController

  skip_authorization_check

  def index
    result = REDIS.get('tulos-alustava.txt')
    render :text => "Vaalitulosta ei ole vielä laskettu." and return unless result

    respond_to do |format|
      format.text { redirect_to result }
    end
  end

  def final
    result = REDIS.get('tulos-lopullinen.txt')
    render :text => "Vaalitulosta ei ole vielä laskettu." and return unless result

    respond_to do |format|
      format.text { redirect_to result }
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
