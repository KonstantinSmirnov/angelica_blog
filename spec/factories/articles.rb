# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    cover_image { File.open('spec/fixtures/images/test_image.png') }
    description 'This is a test description'
  end
end
