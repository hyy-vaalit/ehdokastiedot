class VoterSearch

  include ExtendedPoroBehaviour

  attr_accessor :name, :ssn, :student_number

  attr_reader   :errors

  validates_length_of :name,
                      :minimum => 4,
                      :allow_blank => true

  validates_length_of :ssn, :within => 6..13,
                      :allow_blank => true

  validates_length_of :student_number, :minimum => 6, :allow_blank => true

  validate :at_least_one_search_term

  validate :trim_whitespace

  def to_human
    text = ""
    catenate_with = " AND "

    [ssn, name, student_number].each do |value|
      next if value.blank?

      if text.blank?
        text = "'#{value}'"
      else
        text = text + catenate_with + "'#{value}'"
      end
    end

    text
  end

  protected

  def at_least_one_search_term
    if name.blank? && ssn.blank? && student_number.blank?
      errors.add(:base, "Anna ainakin yksi hakutermi")
      false
    end

    true
  end

  def trim_whitespace
    [:name, :ssn, :student_number].each do |attr|
      if send(attr).respond_to?(:strip)
        send "#{attr}=", send(attr).strip
      end
    end
  end

end
