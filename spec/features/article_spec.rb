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

    context 'on article preview' do
      scenario 'I have a read more button' do
        article.save!

        visit articles_path

        expect(page).to have_text(article.title)
        expect(page).to have_selector('a.btn', text: 'Read more')
      end

      scenario 'just published article has 0 views' do
        article.save!

        visit articles_path

        expect(page).to have_selector('i.fa.fa-eye', text: '0')
      end

      scenario 'published article has views counter' do
        article.save!

        visit article_path(article)
        visit article_path(article)
        visit article_path(article)

        visit articles_path
        expect(page).to have_selector('i.fa.fa-eye', text: '3')
      end

      scenario 'published article has publication date' do
        article.save!
        datetime = article.published_at

        visit articles_path

        expect(page).to have_selector('small.text-muted', text: datetime.strftime('%d %b %Y'))
      end

      scenario 'published article has publication date (2 days ago test)' do
        article.save!
        datetime = 2.days.ago
        article.published_at = datetime
        article.save!

        visit articles_path

        expect(page).to have_selector('small.text-muted', text: datetime.strftime('%d %b %Y'))
      end

      scenario 'I can visit published article' do
        article.save!

        visit articles_path
        click_link 'Read more'

        expect(current_path).to eq(article_path(article))
        expect(page).to have_selector('h1', text: article.title)
      end
    end
  end
end
