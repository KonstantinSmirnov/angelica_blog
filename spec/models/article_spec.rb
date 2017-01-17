require 'rails_helper'

RSpec.describe Article, type: :model do

  describe 'Create' do
    it 'is invalid without title' do
      article = Article.create(
        cover_image: File.open('spec/fixtures/images/test_image.png')
      )

      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without cover image' do
      article = Article.create(
        title: ''
      )

      expect(article).not_to be_valid
      expect(article.errors[:cover_image]).to include("can't be blank")
    end

    it 'is valid with title and cover image' do
      article = Article.create(
        title: 'there is a title',
        cover_image: File.open('spec/fixtures/images/test_image.png')
      )
      expect(article).to be_valid
    end
  end

  describe 'Update' do
    let(:article) { FactoryGirl.create(:article) }

    it 'can not update with empty title' do
      article.title = ''
      article.save

      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'can be updated with different title and content' do
      article.title = 'Another title'
      article.save

      expect(article).to be_valid
    end
  end

  context 'article status' do
    let(:article) { FactoryGirl.create(:article) }

    it 'is draft by default' do
      expect(article.status).to eq('draft')
    end

    it 'can be published' do
      article.published!

      expect(article.status).to eq('published')
    end
  end

end
