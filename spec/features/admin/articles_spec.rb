require 'rails_helper'

feature 'Admin articles' do
  describe 'Visitor' do
    scenario 'does not respond to admin articles path' do
      visit admin_articles_path

      expect(current_path).to eq(root_path)
    end
  end

  describe 'Admin' do
    let(:admin) { FactoryGirl.create(:james_bond) }

    before(:each) do
      log_in_with(admin.email, 'password')
    end

    scenario 'responds to admin articles path' do
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

    describe 'Create' do
      before(:each) do
        visit new_admin_article_path
      end

      scenario 'fails without title' do
        fill_in 'article_content', with: 'Some content'
        click_button 'Save'

        expect(page).to have_text("Please review the problems below")
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'fails without content' do
        fill_in 'article_title', with: 'Some title'
        click_button 'Save'

        expect(page).to have_text("Please review the problems below")
        expect(page).to have_selector('div.article_content span.help-block', text: "can't be blank")
      end

      scenario 'creates new article with title and content' do
        fill_in 'article_title', with: 'Some title'
        fill_in 'article_content', with: 'Some content'
        click_button 'Save'

        expect(page).to have_text('Article has been created')
      end
    end

    describe 'Update' do
      let(:article) { FactoryGirl.create(:article) }

      before(:each) do
        visit edit_admin_article_path(article)
      end

      describe 'Index' do
        scenario 'has edit article link on index page' do
          visit admin_articles_path

          click_link 'Edit'

          expect(current_path).to eq(edit_admin_article_path(article))
        end        
      end


      scenario 'fails without title' do
        fill_in 'article_title', with: ''
        fill_in 'article_content', with: 'Another content'
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'fails without content' do
        fill_in 'article_title', with: 'Something new here'
        fill_in 'article_content', with: ''
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_content span.help-block', text: "can't be blank")
      end

      scenario 'updates article with new title and content' do
        fill_in 'article_title', with: 'New article title'
        fill_in 'article_content', with: 'New article content'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')
      end
    end

    describe 'Delete' do
      let(:article) { FactoryGirl.create(:article) }

      scenario 'deletes article' do
        visit edit_admin_article_path(article)

        click_link 'Delete'

        expect(page).to have_text('Article has been deleted')
      end
    end
  end
end
