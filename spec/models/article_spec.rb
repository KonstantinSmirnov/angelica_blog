require 'rails_helper'

RSpec.describe Article, type: :model do

  it 'has a valid factory for article' do
    article = FactoryGirl.create(:article)

    expect(article).to be_valid
  end

  describe 'Create' do
    it 'is invalid without title' do
      article = FactoryGirl.build(:article, title: '')

      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end
    
    it 'is invalid with title consisting of spacebars' do
      article = FactoryGirl.build(:article, title: '   ')
      
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without cover image' do
      article = FactoryGirl.build(:article, cover_image: '')

      expect(article).not_to be_valid
      expect(article.errors[:cover_image]).to include("can't be blank")
    end

    it 'is invalid without description' do
      article = FactoryGirl.build(:article, description: '')

      expect(article).not_to be_valid
      expect(article.errors[:description]).to include("can't be blank")
    end

    it 'is valid with title, cover image and description' do
      article = FactoryGirl.create(:article)

      expect(article).to be_valid
    end

    it 'adds slug from title by default' do
      article = FactoryGirl.create(:article, title: 'hello world!')

      expect(article).to be_valid
      expect(article.slug).to include('hello-world-')
    end

    it 'has slug transliterated to latin symbols' do
      article = FactoryGirl.create(:article, title: 'Это заголовок статьи!')

      expect(article).to be_valid
      expect(article.slug).to include('jeto-zagolovok-stat-i-')
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
    
    it 'can not update with title consisting of spacebars' do
      article.title = '   '
      article.save
      
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'can not update with empty description' do
      article.description = ''
      article.save

      expect(article).not_to be_valid
      expect(article.errors[:description]).to include("can't be blank")
    end

    it 'can be updated with different title, cover image and description' do
      article.title = 'Another title'
      article.cover_image File.open('spec/fixtures/images/test_image.png')
      article.description = 'Another description'
      article.save

      expect(article).to be_valid
    end

    it 'has slug updated with new title' do
      article.title = 'Another title!'
      article.save

      expect(article.slug).to include('another-title-')
    end
    
    it 'slug not updated if title is empty' do
      article.title = 'there is a title'
      article.save
      
      slug = article.slug
      
      article.title = ''
      article.save
      
      expect(article).not_to be_valid
      expect(article.slug).to eq(slug)
    end
    
    it 'slug not updated if title is consisting of spacebars' do
      article.title = 'there is a title'
      article.save
      
      slug = article.slug
      
      article.title = '   '
      article.save
      
      expect(article).not_to be_valid
      expect(article.slug).to eq(slug)
    end

  end

  context 'article status' do
    let(:article) { FactoryGirl.create(:article) }

    it 'is draft by default' do
      expect(article.status).to eq('draft')
      expect(article.published_at).to eq(nil)
    end

    it 'can be published' do
      article.published!

      expect(article.status).to eq('published')
      expect(article.published_at).not_to eq(nil)
    end

    it 'can be unpublished' do
      article.published!
      article.draft!

      expect(article.status).to eq('draft')
      expect(article.published_at).to eq(nil)
    end

    it 'publication date does not update if already published' do
      article.published!
      datetime = article.published_at
      article.published!

      expect(article.status).to eq('published')
      expect(article.published_at).to eq(datetime)
    end
  end

end
