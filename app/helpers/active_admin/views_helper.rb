# N.B. You need to restart Rails Server before changes are applied!

module ActiveAdmin::ViewsHelper
  # Candidate view is shared with ActiveAdmin and Advocates.
  #
  # User should only get here if candidates can be edited.
  # Authorization logic is handled by CanCan.
  def link_to_edit_candidate(scope, candidate)
    if scope == "admin"
      edit_admin_candidate_path(candidate)
    else
      edit_advocates_alliance_candidate_path(candidate.electoral_alliance, candidate)
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
