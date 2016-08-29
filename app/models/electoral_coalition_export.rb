class ElectoralCoalitionExport
  include ExportableToExcel

  def csv_attributes
    [
      "Nimi"          => "name",
      "Järjestys"     => "numbering_order",
      "Lyhenne"       => "shorten",
      "Vaaliliittoja" => :alliance_count
    ]
  end

  def alliance_count(member)
    member.electoral_alliances.count
  end

end
