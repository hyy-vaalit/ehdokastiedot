class HakaAuthError < StandardError; end

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
  #
  # Student number may be a multivalue array such as
  #   "urn:oid:1.3.6.1.4.1.25178.1.2.14"=>
  #     ["urn:schac:personalUniqueCode:int:esi:FI:1.2.246.562.24.987654321",
  #     "urn:schac:personalUniqueCode:int:studentID:helsinki.fi:01234567"]
  #   }
  # in which case the value of Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY is used.
  def parse_student_number(raw)
    value = nil

    if raw.is_a?(Array)
      raw.each do |v|
        value = v if v.starts_with?(Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY)
      end
    elsif raw.is_a?(String)
      if raw.starts_with?(Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY)
        value = raw
      else
        Rails.logger.info <<-MSG.squish
          Login failed because student number not found with key
          #{Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY}
        MSG
        Rails.logger.debug "Failed student number value: #{value}"
        value = nil
      end
    elsif value.blank?
      # TODO: Fail with a friendly error instead of "something went wrong" without student number
      raise HakaAuthError, "Student number missing"
    else
      raise HakaAuthError, "Student number must be given either as String or String[] to preserve the leading zero."
    end

    raise HakaAuthError, "Student number missing" if value.blank?

    value.split(":").last
  end
end
