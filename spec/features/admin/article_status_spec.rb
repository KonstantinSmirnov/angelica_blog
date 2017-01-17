require 'rails_helper'

feature 'ARTICLE STATUS' do

  context 'As a visitor' do
    let(:article) { FactoryGirl.create(:article) }

    it 'I can not see not published article' do
      visit articles_path

      expect(page).not_to have_text(article.title)
    end

    it 'I can see published article' do
      article.published!

      visit articles_path

      expect(page).to have_text(article.title)
    end
  end

  context 'As an admin' do
    let(:admin) { FactoryGirl.create(:james_bond) }
    let(:article) { FactoryGirl.create(:article) }

    before(:each) do
      log_in_with(admin.email, 'password')
      visit edit_admin_article_path(article)
    end

    context 'I change article status' do
      it 'is draft by default' do
        article = Article.create(title: 'There is a title')

        visit edit_admin_article_path(article)

        expect(find("select#article_status").value).to eq('draft')
      end

      it 'is published' do
        visit edit_admin_article_path(article)

        select 'published', from: 'article_status'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')
        expect(find("select#article_status").value).to eq('published')
      end

    end
  end

end
