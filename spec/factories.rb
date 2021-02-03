FactoryBot.define do

  factory :admin_user do
    email { 'user@example.com' }
  end

  factory :imported_voter do
    name { 'Armas Aappa' }
    ssn { '020486-1234' }
    student_number { '012617061' }
    extent_of_studies { 1 }
    faculty { 55 }
    start_year { 2014 }
  end

  factory :faculty do
    sequence(:name) {|n| "Faculty #{n}"}
    sequence(:code) {|n| "F#{n}"}
    sequence(:numeric_code) {|n| n}
  end

  factory :electoral_coalition do
    sequence(:name) {|n| "Coalition #{n}"}
    sequence(:shorten) {|n| "c #{n}"}
    sequence(:numbering_order) {|n| n+1}
  end

  factory :electoral_alliance do
    sequence(:name) {|n| "Alliance #{n}"}
    sequence(:shorten) {|n| "a #{n}"}
    expected_candidate_count { 2 }
    secretarial_freeze { true }
    electoral_coalition
  end

  factory :candidate do
    sequence(:email) {|n| "matti.meikalainen.#{n}@example.com"}
    sequence(:lastname) {|n| "Meikalainen #{n}"}
    sequence(:firstname) {|n| "Matti #{n} Sakari"}
    sequence(:candidate_name) {|n| "Meikalainen, Matti Sakari"}
    social_security_number { 'sec id' }
    faculty
    electoral_alliance
  end

  factory :voting_area do
    sequence(:code) {|n| "VA#{n}"}
    sequence(:name) {|n| "Voting area #{n}"}
    ready { true }
    submitted { true }
  end

  factory :vote do
    voting_area
    candidate
    sequence(:amount) { |n| n+10 }
  end

  factory :result do

  end

  factory :coalition_result do
    result
    electoral_coalition
    sequence(:vote_sum_cache) { |n| n+100 }
  end

  factory :alliance_result do
    result
    electoral_alliance
    sequence(:vote_sum_cache) { |n| n+10 }
  end

  factory :candidate_result do
    result
    candidate
    sequence(:vote_sum_cache) { |n| n+10 }
  end

  factory :draw_candidate_result, :class => CandidateResult do
    electoral_alliance_id { '1' }
    vote_sum_cache { '10' }
  end

  factory :candidate_result_with_proportionals, :parent => :candidate_result do |candidate_result|
    candidate_result.after(:create) do |cr|
      create(:ordered_coalition_proportional, :result => cr.result, :candidate => cr.candidate)
      create(:ordered_alliance_proportional, :result => cr.result, :candidate => cr.candidate)
    end
  end

  factory :coalition_proportional do
    number { (rand * rand(100)).to_f }
    result
    candidate
  end

  factory :alliance_proportional do
    number { (rand * rand(100)).to_f }
    result
    candidate
  end

  factory :ordered_alliance_proportional, :class => AllianceProportional do
    sequence(:number) { |n| (n*10).to_f }
    result
    candidate
  end

  factory :ordered_coalition_proportional, :class => CoalitionProportional do
    sequence(:number) { |n| (n*10).to_f }
    result
    candidate
  end

  factory :ready_voting_area, :parent => :voting_area do |area|
    area.ready { true }
  end

  factory :ready_voting_area_with_votes_for, :parent => :ready_voting_area do |area|
    area.after(:create) { |a| create(:vote, :candidate => candidate, :amount => amount)}
  end

  factory :unready_voting_area, :parent => :voting_area do |area|
    area.ready { false }
  end

  factory :voted_candidate, :parent => :candidate do |candidate|
    candidate.after(:create) { |c| create(:vote, :candidate => c, :amount => 1234) }
  end

  factory :result_with_alliance_proportionals_and_candidates, :parent => :result do |result|
    result.after(:create) { |r| 10.times { create(:ordered_alliance_proportional, :result => r) } }
  end

  factory :result_with_coalition_proportionals_and_candidates, :parent => :result do |result|
    result.after(:create) { |r| 10.times { create(:candidate_result_with_proportionals, :result => r) } }
  end

  factory :electoral_alliance_with_candidates, :parent => :electoral_alliance do |alliance|
    alliance.after(:create) { |a| 10.times { a.candidates << create(:candidate, :electoral_alliance => a) } }
  end

  factory :electoral_coalition_with_alliances_and_candidates, :parent => :electoral_coalition do |coalition|
    coalition.after(:create) { |c| 10.times { c.electoral_alliances << create(:electoral_alliance_with_candidates, :electoral_coalition => c) } }
  end
end
