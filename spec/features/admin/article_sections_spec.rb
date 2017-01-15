require 'rails_helper'

feature 'Article' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:article) { FactoryGirl.create(:article) }

  before(:each) do
    log_in_with(admin.email, 'password')
  end

  context 'add text section' do
    it 'fails without text', js: true do
      visit edit_admin_article_path(article)

      click_link 'Add text section'
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('.article_section .form-group span.help-block', text: "can't be blank")
    end

    it 'succeed with valid text', js: true do
      visit edit_admin_article_path(article)
      click_link 'Add text section'

      time = Time.now.to_i
      fill_in "article_sections_attributes_#{time}_text", with: 'There is some text'
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
      expect(find_field("article_sections_attributes_0_text").value).to eq('There is some text')
    end
  end

  context 'update text section' do
    it 'fails without text', js: true do
      section = article.sections.create(text: 'There is some text')
      section.text!
      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is some text')
      fill_in 'article_sections_attributes_0_text', with: ''
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('.article_section .form-group span.help-block', text: "can't be blank")
    end

    it 'succeed with valid text', js: true do
      section = article.sections.create(text: 'There is some text')
      section.text!
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

  context 'delete text section' do
    it 'disappears after clicking delete icon', js: true do
      section = article.sections.create(text: 'There is some text')
      section.text!
      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is some text')
      expect(page).to have_selector('div.article_section', visible: true)
      click_link 'Delete section'

      expect(page).to have_selector('div.article_section', visible: false)
    end

    it 'destroyed successfully', js: true do
      section = article.sections.create(text: 'There is some text')
      section.text!
      visit edit_admin_article_path(article)

      expect(find_field('article_sections_attributes_0_text').value).to eq('There is some text')

      click_link 'Delete section'
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
      expect(article.sections.count).to eq(0)
    end
  end

  context 'add image section' do
    it 'fails without image file', js: true do
      visit edit_admin_article_path(article)

      click_link 'Add image section'
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_text("can't be blank")
    end

    it 'succeed with image file', js: true do
      visit edit_admin_article_path(article)

      click_link 'Add image section'
      attach_file('Image', Rails.root + "spec/fixtures/images/test_image.png")
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
    end
  end

  context 'update image section' do
    it 'succeed with another image file' do
      section = FactoryGirl.create(:image_section)
      visit edit_admin_article_path(section.article)

      attach_file('Image', Rails.root + "spec/fixtures/images/another_test_image.png")
      click_button 'Save'

      expect(page).to have_text('Article has been updated')
    end
  end

end
