# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :text_section, class: Section do
    section_type 'text'
    text "MyText"
    article
  end
end
