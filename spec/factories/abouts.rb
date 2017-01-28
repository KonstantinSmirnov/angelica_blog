# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :about do
    text 'There is some text'
    image { File.open('spec/fixtures/images/test_image.png') }
  end
end
