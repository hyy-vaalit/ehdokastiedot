class ElectoralAllianceExport
  include ExportableToExcel

  # Strings are methods of the collection's member
  # Symbols are methods of the exporter
  def csv_attributes
    [
      "Nimi"        => "name",
      "Järjestys"   => "numbering_order",
      "Lyhenne"     => "shorten",
      "Ehdokkaita"  => :candidate_count,
      "Vaalirengas" => :coalition_name
    ]
  end

  def candidate_count(member)
    member.candidates.count
  end

  def coalition_name(member)
    member.electoral_coalition&.name
  end
end
