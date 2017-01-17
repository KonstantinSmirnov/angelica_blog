require 'rails_helper'

feature 'ARTICLE' do
  context 'As a visitor' do
    let(:article) { FactoryGirl.create(:article, status: 'published') }

    scenario 'I can see published articles' do
      article.save!

      visit articles_path

      expect(page).to have_text(article.title)
      expect(page).to have_text(article.description)
    end

    scenario 'I can visit published articles' do
      article.save!

      visit article_path(article)

      expect(current_path).to eq(article_path(article))
      expect(page).to have_text(article.title)
    end
  end
end
