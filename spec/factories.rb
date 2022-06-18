FactoryBot.define do

  factory :admin_user do
    email { 'user@example.com' }
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
    sequence(:student_number) { |n| '01234#{n}' }
    faculty
    electoral_alliance
  end

  factory :electoral_alliance_with_candidates, :parent => :electoral_alliance do |alliance|
    alliance.after(:create) { |a| 10.times { a.candidates << create(:candidate, :electoral_alliance => a) } }
  end

  factory :electoral_coalition_with_alliances_and_candidates, :parent => :electoral_coalition do |coalition|
    coalition.after(:create) { |c| 10.times { c.electoral_alliances << create(:electoral_alliance_with_candidates, :electoral_coalition => c) } }
  end
end
