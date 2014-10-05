class ImportedVoter
  # Required dependency for ActiveModel::Errors
  # http://api.rubyonrails.org/classes/ActiveModel/Errors.html
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  def initialize(args={})
    @errors = ActiveModel::Errors.new(self)

    set_data_from(args[:data])
    # self.name           = args[:name]
    # self.ssn            = args[:ssn]
    # self.student_number = args[:student_number]
  end

  private

  def set_data_from(exported_line)
    puts "#{exported_line}"
  end

end
