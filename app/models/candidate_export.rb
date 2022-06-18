class CandidateExport
  include ExportableToExcel

  # Strings are methods of the collection's member
  # Symbols are methods of the exporter
  def csv_attributes
    [
      "Ehdokasnumero" => "candidate_number",
      "Sukunimi" => "lastname",
      "Etunimi" => "firstname",
      "Ehdokasnimi" => "candidate_name",
      "Opiskelijanumero" => "student_number",
      "Puhelin" => "phone_number",
      "Email" => "email",
      "Katuosoite" => "address",
      "Postinumero" => "postal_code",
      "Kaupunki" => "postal_city",
      "Vaaliliiton ID" => "electoral_alliance_id",
      "Vaaliliitto" => :alliance_name,
      "Tiedekuntakoodi" => :faculty_code,
      "Huomioita" => "notes"
    ]
  end

  def alliance_name(member)
    member.electoral_alliance.name
  end

  def faculty_code(member)
    member.faculty ? member.faculty.code : ""
  end
end
