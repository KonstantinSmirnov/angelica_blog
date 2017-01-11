require 'rails_helper'

RSpec.describe Section, type: :model do

  it 'has a valid factory' do
    section = FactoryGirl.create(:section)

    expect(section).to be_valid
  end

  it 'is invalid without article' do
    section = Section.create(text: 'Some text')

    expect(section).not_to be_valid
    expect(section.errors[:article]).to include("can't be blank")
  end

  it 'is valid with article' do
    article = FactoryGirl.create(:article)
    section = article.sections.create(text: 'Some text')

    expect(section).to be_valid
  end

  it 'is invalid without text' do
    article = FactoryGirl.create(:article)
    section = article.sections.create(text: '')

    expect(section).not_to be_valid
    expect(section.errors[:text]).to include("can't be blank")
  end

  describe 'Update' do

    it 'can not be updated without text' do
      section = FactoryGirl.create(:section)

      section.text = ''
      section.save

      expect(section).not_to be_valid
      expect(section.errors[:text]).to include("can't be blank")
    end

    it 'can be updated with valid text' do
      section = FactoryGirl.create(:section)

      section.text = 'New text'
      section.save

      expect(section).to be_valid
    end
  end

  describe 'Destroy' do

    it 'parent article still exists after section deleted' do
      article = FactoryGirl.create(:article)
      section = article.sections.create(text: 'some text')

      expect { section.destroy! }.to change { Article.count }.by(0)
      .and change { Section.count }.by(-1)
    end

    it 'deletes together with article' do
      article = FactoryGirl.create(:article)
      section = article.sections.create(text: 'some text')

      expect { article.destroy! }.to change { Article.count }.by(-1)
      .and change { Section.count }.by(-1)
    end
  end
end
