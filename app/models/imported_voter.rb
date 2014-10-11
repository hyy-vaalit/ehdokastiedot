# Import Student Data from HY Opiskelijarekisteri
#
# Format:
#
# 200583080H012617061Aaltio Poro J J               20122     H30
#
# Kun ensimmäinen merkki alkaa ykkösestä (Oracle), muotona on:
#
#   htunnus                   position(1:10) char,
#   onumero                   position(11:19) char,
#   nimi                      position(20:49) char,
#   aloitusv                  position(50:53) char,
#   okattav                   position(54:55) char,
#   tiedek                    position(61:62) char
#
# Rubyssä ensimmäinen merkki alkaa nollasta.
# Ks. myös testit.
#
class ImportedVoter
  # Required dependency for ActiveModel::Errors
  # http://api.rubyonrails.org/classes/ActiveModel/Errors.html
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  attr_accessor :ssn, :student_number, :name, :start_year, :extent, :faculty

  def initialize(args={})
    @errors = ActiveModel::Errors.new(self)

    set_data_from(args[:data])
  end

  private

  def set_data_from(exported_line)
    self.name = parse_name(exported_line)
    self.ssn = parse_ssn(exported_line)
    self.student_number = parse_student_number(exported_line)
    self.start_year = parse_start_year(exported_line)
    self.extent = parse_extent(exported_line)
    self.faculty = parse_faculty(exported_line)
  end

  def parse_name(data)
    data[19..48].strip()
  end

  # N.B. Opiskelijarekisterin hetussa ei tule väliviivaa mukana
  def parse_ssn(data)
    birthdate = data[0..5].strip()
    separator = get_separator(birthdate)
    suffix = data[6..9]

    return birthdate + separator + suffix
  end

  # TODO: Vuoden 2014 Opiskelijarekisterin datassa ei huomioitu
  #       2000-luvulla syntyneitä lainkaan. Tilanne voi muuttua myöhemmin.
  def get_separator(birthdate)
    return "-"
  end

  def parse_student_number(data)
    data[10..18].strip()
  end

  def parse_start_year(data)
    data[49..52].strip()
  end

  def parse_faculty(data)
    data[60..61].strip()
  end

  def parse_extent(data)
    data[53..54].strip()
  end

end
