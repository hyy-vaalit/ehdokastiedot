class Voter < ActiveRecord::Base
  attr_accessible :name, :ssn, :start_year, :student_number, :faculty, :faculty_id, :extent_of_studies

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

  def self.by_name
    reorder(:name)
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
