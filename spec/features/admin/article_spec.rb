require 'rails_helper'

feature 'ARTICLE' do
  context 'As a visitor' do
    scenario 'I should not have access to admin articles path' do
      visit admin_articles_path

      expect(current_path).to eq(root_path)
    end
  end

  describe 'As an admin' do
    let(:admin) { FactoryGirl.create(:james_bond) }
    let(:article) { FactoryGirl.create(:article) }

    before(:each) do
      log_in_with(admin.email, 'password')
    end

    scenario 'I should have access to admin articles path' do
      visit admin_articles_path

      expect(current_path).to eq(admin_articles_path)
      expect(page).to have_selector("a.active", text: 'My articles')
    end

    scenario 'I should have a link to add new article' do
      visit admin_articles_path

      click_link 'Add'

      expect(current_path).to eq(new_admin_article_path)
      expect(page).to have_text("New article")
    end

    scenario 'I should have a link to edit article on admin articles page' do
      article = Article.create(title: 'test')
      visit admin_articles_path

      click_link 'Edit'

      expect(current_path).to eq(edit_admin_article_path(article))
    end

    context 'I try to create new article' do
      before(:each) do
        visit new_admin_article_path
      end

      scenario 'it fails without title' do
        click_button 'Save'

        expect(page).to have_text("Please review the problems below")
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'it succeeded with title' do
        fill_in 'article_title', with: 'Some title'
        click_button 'Save'

        expect(page).to have_text('Article has been created')
      end
    end

    describe 'I try to update article' do
      before(:each) do
        visit edit_admin_article_path(article)
      end

      scenario 'it fails without title' do
        fill_in 'article_title', with: ''
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'it succeeded with new title' do
        fill_in 'article_title', with: 'New article title'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')
      end
    end

    describe 'I try to delete article' do
      scenario 'it succeeded' do
        visit edit_admin_article_path(article)

        click_link 'Delete'

        expect(page).to have_text('Article has been deleted')
      end
    end
  end
end
