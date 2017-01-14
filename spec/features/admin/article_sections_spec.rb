require 'rails_helper'

feature 'Article section' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:article) { FactoryGirl.create(:article) }

  before(:each) do
    log_in_with(admin.email, 'password')
  end

  describe 'Create' do

    it 'fails without text', js: true do
      visit edit_admin_article_path(article)

      click_link 'Add section'
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('.article_section .form-group span.help-block', text: "can't be blank")
    end

    it 'adds with valid text', js: true do
      visit edit_admin_article_path(article)
      click_link 'Add section'

      time = Time.now.to_i
      fill_in "article_sections_attributes_#{time}_text", with: 'There is some text'
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
      expect(find_field("article_sections_attributes_0_text").value).to eq('There is some text')
    end

  end

  describe 'Update' do

    it 'fails without text', js: true do
      section = article.sections.create(text: 'There is some text')
      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is some text')
      fill_in 'article_sections_attributes_0_text', with: ''
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('.article_section .form-group span.help-block', text: "can't be blank")
    end

    it 'updates with valid text', js: true do
      section = article.sections.create(text: 'There is some text')
      visit edit_admin_article_path(article)
      expect(find_field("article_sections_attributes_0_text").value).to have_text('There is some text')

      fill_in 'article_sections_attributes_0_text', with: 'There is another text'
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
      expect(find_field('article_sections_attributes_0_text').value).to eq('There is another text')

      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is another text')
    end

  end

  describe 'Delete' do

    it 'disappears after clicking delete icon', js: true do
      article.sections.create(text: 'There is some text')
      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is some text')
      expect(page).to have_selector('div.article_section', visible: true)
      click_link 'Delete section'

      expect(page).to have_selector('div.article_section', visible: false)
    end

    it 'destroyed successfully', js: true do
      article.sections.create(text: 'There is some text')
      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is some text')

      click_link 'Delete section'
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
      expect(article.sections.count).to eq(0)
    end


  end
end
