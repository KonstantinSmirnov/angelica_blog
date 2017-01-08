require 'rails_helper'

RSpec.describe Article, type: :model do

  describe 'Create' do
    it 'is invalid without title' do
      article = Article.create(
        content: 'some content'
      )

      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without content' do
      article = Article.create(
        title: 'this is a title'
      )

      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it 'is valid with title and content' do
      article = Article.create(
        title: 'there is a title',
        content: 'There is a content'
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

    it 'can not update with empty content' do
      article.content = ''
      article.save

      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it 'can be updated with different title and content' do
      article.title = 'Another title'
      article.content = 'Another content'
      article.save

      expect(article).to be_valid
    end
  end

end
