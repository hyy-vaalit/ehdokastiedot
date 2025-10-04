class CandidateExportReduced
  include ExportableToExcel

  # Strings are methods of the collection's member
  # Symbols are methods of the exporter
  def csv_attributes
    [
      "Ehdokasnumero" => "candidate_number",
      "Sukunimi" => "lastname",
      "Etunimi" => "firstname",
      "Ehdokasnimi" => "candidate_name",
      "Vaaliliiton ID" => "electoral_alliance_id",
      "Vaaliliitto" => :alliance_name
    ]
  end

  def alliance_name(member)
    member.electoral_alliance.name
  end
end
