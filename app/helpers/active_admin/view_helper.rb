module ActiveAdmin::ViewHelper

  def edit_link candidate
    raw "<td>#{link_to t('edit'), '#edit'}</td>" if can? :report_fixes, candidate
  end

end
