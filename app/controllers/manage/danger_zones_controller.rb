class Manage::DangerZonesController < ManageController
  def show
    @configuration = GlobalConfiguration.instance
  end

  def give_candidate_numbers
    if Candidate.give_numbers!
      redirect_to manage_candidates_path, notice: 'Ehdokkaat on numeroitu!'
    else
      redirect_to manage_danger_zone_path, alert: <<-MSG.squish
        Kaikki liitot eivät ole valmiina,
        renkailta puuttuu järjestys
        tai kaikilla liitoilla ei ole rengasta.
      MSG
    end
  end

end
