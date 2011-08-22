FactoryGirl.define do

  factory :admin_user do
    email 'user@example.com'
  end

  factory :faculty do
    sequence(:name) {|n| "Faculty #{n}"}
    sequence(:code) {|n| "F#{n}"}
  end

  factory :electoral_coalition do
    sequence(:name) {|n| "Coalition #{n}"}
    sequence(:number_order) {|n| n+1}
  end

  factory :electoral_alliance do
    sequence(:name) {|n| "Alliance #{n}"}
    delivered_candidate_form_amount 2
    secretarial_freeze true
    electoral_coalition
    primary_advocate_lastname 'First last'
    primary_advocate_firstname 'First first'
    primary_advocate_social_security_number 'First ssn'
    primary_advocate_address 'First address'
    primary_advocate_postal_information 'First postal'
    primary_advocate_phone 'First phone'
    primary_advocate_email 'First email'
    secondary_advocate_lastname 'Second last'
    secondary_advocate_firstname 'Second first'
    secondary_advocate_social_security_number 'Second ssn'
    secondary_advocate_address 'Second address'
    secondary_advocate_postal_information 'Second postal'
    secondary_advocate_phone 'Second phone'
    secondary_advocate_email 'Second email'
  end

  factory :candidate do
    sequence(:email) {|n| "foo#{n}@example.com"}
    lastname 'Meikalainen'
    firstname 'Matti Sakari'
    candidate_name 'Meikalainen, Matti Sakari'
    social_security_number 'sec id'
    faculty
    electoral_alliance
  end

  factory :voting_area do
    sequence(:code) {|n| "VA#{n}"}
    sequence(:name) {|n| "Voting area #{n}"}
    ready true
    taken true
    password 'foobar123'
  end

  factory :vote do
    voting_area
    candidate
    vote_count { (1+1*rand(100)).to_i }
  end

end
