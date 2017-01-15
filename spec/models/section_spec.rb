require 'rails_helper'

RSpec.describe Section, type: :model do

  it 'has a valid factory for text section' do
    section = FactoryGirl.create(:text_section)

    expect(section).to be_valid
  end

  it 'has a valid factory for image section' do
    section = FactoryGirl.create(:image_section)

    expect(section).to be_valid
  end

  describe 'common tests for section' do
    context 'create new section' do
      it 'is invalid without article' do
        section = Section.create(text: 'Some text', section_type: 'text')

        expect(section).not_to be_valid
        expect(section.errors[:article]).to include("can't be blank")
      end

      it 'is valid with article' do
        article = FactoryGirl.create(:article)
        section = article.sections.create(text: 'Some text', section_type: 'text')

        expect(section).to be_valid
      end
    end

    context 'destroy section' do
      it 'parent article still exists after section deleted' do
        section = FactoryGirl.create(:text_section, text: 'some text', section_type: 'text')

        expect { section.destroy! }.to change { Article.count }.by(0)
        .and change { Section.count }.by(-1)
      end

      it 'deletes together with article' do
        section = FactoryGirl.create(:text_section, text: 'some text', section_type: 'text')

        expect { section.article.destroy! }.to change { Article.count }.by(-1)
        .and change { Section.count }.by(-1)
      end
    end
  end

  context 'text section' do

    it 'is invalid without text' do
      article = FactoryGirl.create(:article)
      section = article.sections.create(text: '', section_type: 'text')

      expect(section).not_to be_valid
      expect(section.errors[:text]).to include("can't be blank")
    end

    describe 'update' do

      it 'can not be updated without text' do
        section = FactoryGirl.create(:text_section)

        section.text = ''
        section.save

        expect(section).not_to be_valid
        expect(section.errors[:text]).to include("can't be blank")
      end

      it 'can be updated with valid text' do
        section = FactoryGirl.create(:text_section)

        section.text = 'New text'
        section.save

        expect(section).to be_valid
      end
    end
  end

  context 'image section' do
    it 'fails without image' do
      section = FactoryGirl.build(:image_section, image: '')

      expect(section).not_to be_valid
      expect(section.errors[:image]).to include('the formats allowed are: .jpeg, .jpg, .png, .gif')
    end

    it 'is valid with image' do
      section = FactoryGirl.create(:image_section)

      expect(section).to be_valid
    end

    describe 'update' do
      it 'fails without new image' do
        section = FactoryGirl.create(:image_section)

        section.image = ''
        section.save

        expect(section).not_to be_valid
        expect(section.errors[:image]).to include('the formats allowed are: .jpeg, .jpg, .png, .gif')
      end

      it 'succeed with new image' do
        section = FactoryGirl.create(:image_section)

        section.image = Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/images/another_test_image.png')))
        section.save!

        expect(section).to be_valid
      end
    end

  end

end
