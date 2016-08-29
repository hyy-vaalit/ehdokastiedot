# Exports given data to CSV and converts to ISO-8859-1.
# Excel cannot display UTF-8 properly as of 2014.
#
# See example usage in ElectoralAllianceExport.
module ExportableToExcel
  extend ActiveSupport::Concern

  included do

    def initialize(collection)
      @collection = collection
    end

    def to_csv(encoding:)

      CSV.generate do |csv|
        csv << csv_header(self.csv_attributes, encoding)

        @collection.each do |member|
          csv << csv_attributes_encoded(member, self.csv_attributes, encoding)
        end
      end
    end

    private

    def csv_header(exportable_attributes, encoding)
      encoded_header = []

      keys_of(exportable_attributes).each do |attr|
        encoded_header << to_encoding(attr, encoding)
      end

      encoded_header
    end

    def csv_attributes_encoded(member, exportable_attributes, encoding)
      encoded_attributes = []

      values_of(exportable_attributes).each do |attr|
        # Retrieve attribute value from collection's member
        if attr.is_a? String
          encoded_attributes << to_encoding(member.send(attr), encoding)
        else # Retrieve value froma a local method, given member as a parameter
          encoded_attributes << to_encoding(self.send(attr, member), encoding)
        end
      end

      encoded_attributes
    end

    def values_of(hash)
      hash.map(&:values).flatten
    end

    def keys_of(hash)
      hash.map(&:keys).flatten
    end

    def to_encoding(value, encoding)
      value.to_s.encode(encoding,
                        :invalid => :replace,
                        :undef   => :replace,
                        :replace => "?")
    end

  end

end
