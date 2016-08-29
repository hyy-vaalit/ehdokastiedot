class Voter < ActiveRecord::Base

  belongs_to :faculty

  belongs_to :voting_area

  validates_presence_of :name, :ssn, :student_number, :faculty

  validates_uniqueness_of :ssn, :student_number

  validates_length_of :name, :minimum => 4
  validates_length_of :ssn, :minimum => 6
  validates_length_of :student_number, :minimum => 6

  def self.match_scope_condition(col, query)
    arel_table[col].matches("%#{query}%")
  end

  # Voter.matching(:name, "first", "last") => first AND last
  # Voter.matching(:name, "first", "last", :operator => :or ) => first OR last
  scope :matching, lambda {|*args|
    col, opts = args.shift, args.extract_options!
    op = opts[:operator] || :and
    where args.flatten.map {|query| match_scope_condition(col, query) }.inject(&op)
  }

  # Voter.matching_name("first", "last") => first AND last
  scope :matching_name, lambda {|*query|
    matching(:name, *query)
  }

  scope :matching_ssn, lambda {|*query|
    matching(:ssn, *query)
  }

  scope :matching_student_number, lambda {|*query|
    matching(:student_number, *query)
  }

  def self.voted
    where("voted_at IS NOT NULL")
  end

  # Women = People whoe Ssn last number is even
  def self.women
    select("ssn").where("substring(ssn from '\\d{6}[-A]([0-9]{3})\\w$')::int % 2 = 0")
  end

  # Men = People whoe Ssn last number is odd
  def self.men
    select("ssn").where("substring(ssn from '\\d{6}[-A]([0-9]{3})\\w$')::int % 2 = 1")
  end

  def self.unknown_gender_count
    Voter.count - Voter.men.count - Voter.women.count
  end

  def self.unknown_gender_voted_count
    Voter.voted.count - Voter.voted.men.count - Voter.voted.women.count
  end

  # If you change the result of this, please ensure that the voting area related statistics
  # for vaalitulos.hyy.fi still work. This is tightly coupled to the JSON format which is tightly
  # coupled to vaalitulos.hyy.fi.
  def self.count_by_area
    voted
      .group('voting_area_id')
      .count('id')
  end

  def self.by_name
    reorder(:name)
  end

  def self.for_export
    by_name
  end

  def self.create_from!(imported_voter)
    create!(
        :ssn               => imported_voter.ssn,
        :student_number    => imported_voter.student_number,
        :name              => imported_voter.name,
        :start_year        => imported_voter.start_year,
        :extent_of_studies => imported_voter.extent_of_studies,
        :faculty           => Faculty.find_by_numeric_code!(imported_voter.faculty)
    )
  end

  def can_vote?
    voted_at.nil?
  end

  def has_voted?
    !can_vote?
  end

  def mark_voted!(voting_area)
    if can_vote?
      self.voted_at = Time.now
      self.voting_area = voting_area

      return save()
    else
      return false
    end
  end

end
