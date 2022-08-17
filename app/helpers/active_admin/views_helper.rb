#
# N.B. Restart Rails Server to apply changes in ActiveAdmin
#
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

  def link_to_accept_candidate_to_alliance(scope, candidate)
    if scope == "admin"
      admin_candidate_path(candidate, candidate: { alliance_accepted: true })
    else
      advocates_alliance_candidate_confirm_alliance_path(
        candidate.electoral_alliance,
        candidate
      )
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
