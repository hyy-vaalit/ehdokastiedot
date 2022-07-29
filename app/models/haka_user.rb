class HakaUser
  attr_accessor :student_number, :email, :fullname, :firstname, :lastname, :homeorg

  def initialize(attrs:)
    attrs = attrs.symbolize_keys

    @student_number = parse_student_number(attrs[:student_number])
    @email = attrs[:email]
    @fullname = attrs[:fullname]
    @firstname = attrs[:firstname]
    @lastname = attrs[:lastname]
    @homeorg = attrs[:homeorg]
  end

  def candidates
    Candidate.where(student_number: student_number)
  end

  def advocate_user
    AdvocateUser.find_by(student_number: student_number)
  end

  protected

  # Parse actual student id from University of Helsinki's format:
  #   urn:mace:terena.org:schac:personalUniqueCode:int:studentID:helsinki.fi:165934
  #
  # Returns the number value of the last URN attribute:
  #   raw "urn:schac:personalUniqueCode:fi:yliopisto.fi:x8734"
  #   will return: "x8734"
  def parse_student_number(raw)
    raise ArgumentError, "Student number missing" if raw.blank?
    if !raw.is_a?(String)
      raise ArgumentError, "Student number must be given as String to preserve the leading zero."
    end

    raw.split(":").last
  end
end
