class Manage::CandidateAttributeChangesController < ManageController

  def index
    @changes = CandidateAttributeChange.by_creation
  end

  protected

  def authorize_this!
    authorize! :candidate_attribute_changes, @current_admin_user
  end
end
