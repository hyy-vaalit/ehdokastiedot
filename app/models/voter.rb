class Voter < ActiveRecord::Base
  attr_accessible :name, :ssn, :start_year, :student_number, :faculty

  belongs_to :faculty

  belongs_to :voting_area

  validates_presence_of :name, :ssn, :start_year, :student_number

  def self.match_scope_condition(col, query)
    arel_table[col].matches("%#{query}%")
  end

  # Voter.matching(:name, "first", "last") => first OR last
  # Voter.matching(:name, "first", "last", :operator => :and ) => first AND last
  scope :matching, lambda {|*args|
    col, opts = args.shift, args.extract_options!
    op = opts[:operator] || :or
    where args.flatten.map {|query| match_scope_condition(col, query) }.inject(&op)
  }

  # Voter.matching_name("first", "last") => first OR last
  scope :matching_name, lambda {|*query|
    matching(:name, *query)
  }

  def can_vote?
    voted_at.nil?
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
