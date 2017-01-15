require 'rails_helper'

feature 'Article' do
  describe 'Visitor' do
    scenario 'does not have access to admin articles path' do
      visit admin_articles_path

      expect(current_path).to eq(root_path)
    end
  end

  describe 'Admin' do
    let(:admin) { FactoryGirl.create(:james_bond) }
    let(:article) { FactoryGirl.create(:article) }

    before(:each) do
      log_in_with(admin.email, 'password')
    end

    scenario 'has access to admin articles path' do
      visit admin_articles_path

      expect(current_path).to eq(admin_articles_path)
      expect(page).to have_selector("a.active", text: 'Articles')
    end

    scenario 'has add new article link' do
      visit admin_articles_path

      click_link 'Add'

      expect(current_path).to eq(new_admin_article_path)
      expect(page).to have_text("New article")
    end

    describe 'Index' do
      scenario 'has edit article link on index page' do
        article = Article.create(title: 'test')
        visit admin_articles_path

        click_link 'Edit'

        expect(current_path).to eq(edit_admin_article_path(article))
      end
    end

    describe 'Create' do
      before(:each) do
        visit new_admin_article_path
      end

      scenario 'fails without title' do
        click_button 'Save'

        expect(page).to have_text("Please review the problems below")
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'creates new article with title' do
        fill_in 'article_title', with: 'Some title'
        click_button 'Save'

        expect(page).to have_text('Article has been created')
      end
    end

    describe 'Update' do
      before(:each) do
        visit edit_admin_article_path(article)
      end

      scenario 'fails without title' do
        fill_in 'article_title', with: ''
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'updates article with new title' do
        fill_in 'article_title', with: 'New article title'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')
      end
    end

    describe 'Delete' do
      scenario 'deletes article' do
        visit edit_admin_article_path(article)

        click_link 'Delete'

        expect(page).to have_text('Article has been deleted')
      end
    end

    context 'article status' do
      it 'is draft by default' do
        article = Article.create(title: 'There is a title')

        visit edit_admin_article_path(article)

        expect(find("select#article_status").value).to eq('draft')
      end

      it 'can be published' do
        visit edit_admin_article_path(article)

        select 'published', from: 'article_status'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')
        expect(find("select#article_status").value).to eq('published')
      end
    end
  end
end
