class Manage::CandidateAttributeChangesController < ManageController

  def index
    @changes = CandidateAttributeChange.by_creation
  end

end
