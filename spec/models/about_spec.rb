require 'rails_helper'

RSpec.describe About, type: :model do
  it 'has a valid factory' do
    about = FactoryGirl.create(:about)

    expect(about).to be_valid
  end

  context 'create new about' do
    it 'is invalid without text' do
      about = FactoryGirl.build(:about, text: '')

      expect(about).not_to be_valid
      expect(about.errors[:text]).to include("can't be blank")
    end

    it 'is valid with text' do
      about = FactoryGirl.create(:about, text: 'some text')

      expect(about).to be_valid
    end

  end

  context 'update about' do
    let(:about) { FactoryGirl.create(:about) }

    it 'is invalid with empty text' do
      about.text = ''
      about.save

      expect(about).not_to be_valid
      expect(about.errors[:text]).to include("can't be blank")
    end

    it 'is valid with another text' do
      about.text = 'there is another text'
      about.save

      expect(about).to be_valid
    end
  end

  context 'delete about' do
    let!(:about_page) { FactoryGirl.create(:about) }
    it 'should succeed' do
      expect { about_page.destroy }.to change{ About.count }.by(-1)
    end
  end


end
