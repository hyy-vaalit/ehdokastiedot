require 'csv'

class CandidateDecorator < ApplicationDecorator
  decorates :candidate


  # Exports to Excel readable CSV (converts UTF-8 to ISO-8859-1).
  # Please note: decorate(candidates) is dead slow for large collection.
  # With about 1000 candidates this is ok, but this got completely
  # jammed with 28000 voters. Therefore Voter.to_csv is implemented
  # without Draper and has basically this thing here copypasted.
  #
  # CandidateDecorator#to_csv could be refactored to use the same
  # pattern to keep it DRY.
  def self.to_csv(candidates)
    decorated_candidates = decorate(candidates)

    CSV.generate do |csv|
      csv << decorated_candidates.first.csv_header
      decorated_candidates.each do |candidate|
        csv <<  candidate.csv_attributes_isolatin
      end
    end
  end

  def csv_header
    csv_attribute_data.map(&:keys).flatten
  end

  def csv_attributes_isolatin
    isolatin_attributes = []

    csv_attributes.each do |attr|
      isolatin_attributes << attr.to_s.encode('ISO-8859-1',
                                              :invalid => :replace,
                                              :undef => :replace,
                                              :replace => "?")
    end

    isolatin_attributes
  end

  def csv_attributes
    csv_attribute_data.map(&:values).flatten
  end

  private

  def csv_attribute_data
    [ "Sukunimi" => lastname,
      "Etunimi" => firstname,
      "Ehdokasnimi" => candidate_name,
      "Hetu" => social_security_number,
      "Ehdokasnumero" => candidate_number,
      "Puhelin" => phone_number,
      "Email" => email,
      "Postiosoite" => address,
      "Postitoimipaikka" => postal_information,
      "Vaaliliiton ID" => electoral_alliance_id,
      "Tiedekunta" => faculty ? faculty.code : "",
      "Huomioita" => notes ]
  end
end
