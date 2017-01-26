require 'rails_helper'

feature 'ARTICLE STATUS' do

  context 'As a visitor' do
    let(:article) { FactoryGirl.create(:article) }

    it 'I can not see not published article on home page' do
      visit articles_path

      expect(page).not_to have_text(article.title)
    end

    it 'I can not see not published article' do
      visit article_path(article)

      expect(page).not_to have_text(article.title)
      expect(page).to have_selector('h1', text: '404 page')
    end

    it 'I can see published article' do
      article.published!

      visit root_path

      expect(page).to have_text(article.title)
      expect(page).to have_text(article.description)
    end

    it 'I can not see [Edit] link for published articles' do
      article.published!

      visit root_path

      expect(page).not_to have_text('[Edit]')
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
        article = FactoryGirl.create(:article)

        visit edit_admin_article_path(article)

        expect(find("select#article_status").value).to eq('draft')
        expect(page).not_to have_selector('small.text-muted', text: 'Published')
      end

      it 'is published' do
        visit edit_admin_article_path(article)

        select 'published', from: 'article_status'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')
        expect(find("select#article_status").value).to eq('published')
        expect(page).to have_selector('small.text-muted', text: "Published ")
      end

      it 'published article has link [Edit]' do
        article.published!

        visit root_path
        click_link '[Edit]'

        expect(current_path).to eq(edit_admin_article_path(article))
      end
    end

  end

end
