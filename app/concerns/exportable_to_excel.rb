# Exports given data to CSV and converts to ISO-8859-1.
# Excel cannot display UTF-8 properly as of 2014.
#
# There is duplicate code in CandidateDecorator#to_csv.
# See comments there.
module ExportableToExcel
  extend ActiveSupport::Concern

  included do

    def self.to_csv(collection)

      CSV.generate do |csv|
        csv << csv_header(collection.first.csv_attributes)

        collection.each do |member|
          csv << csv_attributes_isolatin(member.csv_attributes)
        end
      end
    end

    private

    def self.csv_header(exportable_attributes)
      isolatin_header = []

      keys_of(exportable_attributes).each do |attr|
        isolatin_header << to_isolatin(attr)
      end

      isolatin_header
    end

    def self.csv_attributes_isolatin(exportable_attributes)
      isolatin_attributes = []

      values_of(exportable_attributes).each do |attr|
        isolatin_attributes << to_isolatin(attr)
      end

      isolatin_attributes
    end

    def self.values_of(hash)
      hash.map(&:values).flatten
    end

    def self.keys_of(hash)
      hash.map(&:keys).flatten
    end

    def self.to_isolatin(value)
      value.to_s.encode('ISO-8859-1',
                        :invalid => :replace,
                        :undef   => :replace,
                        :replace => "?")
    end

  end

end
