FactoryGirl.define do

  factory :faculty do
    sequence(:name) {|n| "Faculty #{n}"}
    sequence(:code) {|n| "F#{n}"}
  end

  factory :electoral_coalition do
    sequence(:name) {|n| "Coalition #{n}"}
  end

  factory :electoral_alliance do
    sequence(:name) {|n| "Alliance #{n}"}
    delivered_candidate_form_amount 2
    secretarial_freeze false
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

end
