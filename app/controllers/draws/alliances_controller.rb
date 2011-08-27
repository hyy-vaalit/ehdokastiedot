# coding: UTF-8
class Draws::AlliancesController < DrawsController

  before_filter :check_if_finished

  def index
    @alliance_draws = AllianceDraw.all
  end

  def edit
    @alliance_draw = AllianceDraw.find_by_id params[:id]
  end

  def update
    @draw = AllianceDraw.find_by_id params[:id]
    params[:alliance_drawing].sort{|x,y| x.last<=>y.last}.each do |id, value|
      drawing = @draw.alliance_drawings.find_by_id(id)
      drawing.update_attribute :position_in_draw_position, value
    end
    @draw.update_attribute :drawed, true
    redirect_to draws_alliances_path(:anchor => "draw_#{@draw.id}")
  end

  def ready
    if AllianceDraw.count == AllianceDraw.ready.count
      REDIS.set('alliance_draw_status', true)
      redirect_to draws_alliances_path
    else
      redirect_to draws_alliances_path, :notice => 'Kaikkia arvontoja ei ole vielä suoritettu'
    end
  end

  private

  def check_if_finished
    if REDIS.get('alliance_draw_status')
      redirect_to draws_path
      return
    end
  end

end
