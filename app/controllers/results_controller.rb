# coding: UTF-8
class ResultsController < ApplicationController

  skip_authorization_check

  def index
    respond_to do |format|
      format.html { render :inline => REDIS.get('result_output') || 'Ei vielä vaalitulosta', :format => :html, :layout => true }
      format.text { render :text => REDIS.get('result_text_output') || 'Ei vielä vaalitulosta' }
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
