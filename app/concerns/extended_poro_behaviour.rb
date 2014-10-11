# Extended PlainOldRubyObject Behaviour:
#
# Gives PORO classes ability to:
# - validate with Rails objects
# - initialize with a hash of attributes
#
module ExtendedPoroBehaviour
  extend ActiveSupport::Concern

  # Required dependency for ActiveModel::Errors
  # http://api.rubyonrails.org/classes/ActiveModel/Errors.html
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  included do
    def initialize(attributes = {})
      @errors = ActiveModel::Errors.new(self)

      attributes.each do |key, value|
        self.send "#{key}=", value
      end
    end
  end

end
