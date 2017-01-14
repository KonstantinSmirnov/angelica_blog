# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :james_bond, class: Admin do
    email 'james_bond@example.com'
    password 'password'
    password_confirmation 'password'
  end
  factory :admin, class: Admin do
    email 'admin@example.com'
    password 'password'
    password_confirmation 'password'
  end
end
