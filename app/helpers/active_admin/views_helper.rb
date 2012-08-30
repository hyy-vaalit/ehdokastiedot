# N.B. You need to restart Rails Server before changes are applied!

module ActiveAdmin::ViewsHelper
  # Candidate view is shared with ActiveAdmin and Advocates.
  def link_to_edit_candidate(scope, candidate)
    if scope == "admin"
      edit_admin_candidate_path(candidate)
    elsif GlobalConfiguration.candidate_nomination_period_effective?
      edit_advocates_alliance_candidate_path(candidate.electoral_alliance, candidate)
    else
      "KORJAA"
    end
  end

  def friendly_datetime(date)
    return nil if date.nil?
    date.localtime.strftime('%d.%m.%Y %H:%M')
  end

  def friendly_date(date)
    return nil if date.nil?
    date.localtime.strftime('%d.%m.%Y')
  end
end
