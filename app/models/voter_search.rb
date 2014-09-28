class VoterSearch
  # Required dependency for ActiveModel::Errors
  # http://api.rubyonrails.org/classes/ActiveModel/Errors.html
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  attr_accessor :name, :ssn, :student_number

  attr_reader   :errors

  validates_length_of :name,
                      :minimum => 4,
                      :allow_blank => true

  validates_length_of :ssn, :within => 6..13,
                      :allow_blank => true

  validates_length_of :student_number, :minimum => 6, :allow_blank => true

  validate :at_least_one_search_term

  def initialize(args={})
    @errors = ActiveModel::Errors.new(self)

    self.name           = args[:name]
    self.ssn            = args[:ssn]
    self.student_number = args[:student_number]
  end


  protected

  def at_least_one_search_term
    if name.blank? && ssn.blank? && student_number.blank?
      errors.add(:base, "Anna ainakin yksi hakutermi")
      false
    end

    true
  end

end
