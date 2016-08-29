class VoterExport
  include ExportableToExcel

  def csv_attributes
    [
      "Äänestänyt"        => "voted_at",
      "Äänestyspaikka"    => "voting_area_id",
      "Nimi"              => "name",
      "Opiskelijanumero"  => "student_number",
      "Hetu"              => "ssn",
      "Aloitusvuosi"      => "start_year",
      "Opintojen laajuus" => "extent_of_studies",
      "Tiedekunta"        => "faculty_id"
    ]
  end
end
