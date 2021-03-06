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
      article = FactoryGirl.create(:article)
      visit admin_articles_path

      click_link 'Edit'

      expect(current_path).to eq(edit_admin_article_path(article))
    end

    context 'I try to create new article' do
      before(:each) do
        visit new_admin_article_path
      end

      scenario 'it fails without title' do
        attach_file('Cover image', Rails.root + "spec/fixtures/images/test_image.png")
        fill_in 'article_description', with: 'This is article description'

        click_button 'Save'

        expect(page).to have_text("Please review the problems below")
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end
      
      scenario 'it fails with a title which consists only spacebars' do
        attach_file('Cover image', Rails.root + "spec/fixtures/images/test_image.png")
        fill_in 'article_title', with: '   '
        fill_in 'article_description', with: 'This is article description'
        
        click_button 'Save'
        
        expect(page).to have_text("Please review the problems below")
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'it fails without cover image' do
        fill_in 'article_title', with: 'Some title'
        fill_in 'article_description', with: 'This is article description'
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_cover_image span.help-block', text: "can't be blank")
      end

      scenario 'it fails without description' do
        fill_in 'article_title', with: 'Some title'
        attach_file('Cover image', Rails.root + 'spec/fixtures/images/test_image.png')
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_description span.help-block', text: "can't be blank")
      end

      scenario 'it succeed with title, cover image and description' do
        fill_in 'article_title', with: 'Some title'
        attach_file('Cover image', Rails.root + "spec/fixtures/images/test_image.png")
        fill_in 'article_description', with: 'There is a description'
        click_button 'Save'

        expect(page).to have_text('Article has been created')
      end

      scenario 'it has a slug as a param' do
        article = FactoryGirl.create(:article, title: 'there is a title')

        visit article_path(article)

        expect(current_path).to include(article.slug)
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
      
      scenario 'it fails without title for repeated saving' do
        fill_in 'article_title', with: ''
        click_button 'Save'
        click_button 'Save'
        
        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end
      
      scenario 'it fails with a title which consists of only spacebars and repeated saving' do
        fill_in 'article_title', with: '   '
        click_button 'Save'
        click_button 'Save'
        
        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_title span.help-block', text: "can't be blank")
      end

      scenario 'it fails without description' do
        fill_in 'article_description', with: ''
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.article_description span.help-block', text: "can't be blank")
      end

      scenario 'it succeeded with new title and description' do
        fill_in 'article_title', with: 'New article title'
        fill_in 'article_description', with: 'new description'
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
