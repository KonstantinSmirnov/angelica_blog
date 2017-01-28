require 'rails_helper'

feature 'ABOUT PAGE' do

  context 'As a visitor I try to visit About page' do
    scenario 'it fails if is not created' do
      visit '/about'

      expect(page).to have_selector('h1', text: '404 page')
      expect(page).not_to have_selector('.nav-item a.nav-link', text: 'About')
    end

    scenario 'it succeed if is created' do
      about_page = FactoryGirl.create(:about)

      visit '/about'

      expect(current_path).to eq(about_path)
      expect(page).to have_selector('.nav-item a.nav-link.active', text: 'About')
    end
  end

  context 'As a visitor I try to admin about page' do
    scenario 'I have no access' do
      visit edit_admin_about_path

      expect(current_path).not_to eq(edit_admin_about_path)
      expect(current_path).to eq(root_path)
    end
  end

  context 'As an admin I try to create About page' do
    let(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      log_in_with(admin.email, 'password')
    end

    scenario 'I have a link to manage admin page' do
      visit admin_dashboard_path

      click_link 'About page'

      expect(page).to have_selector('a.nav-link.active', text: 'About')
      expect(current_path).to eq(edit_admin_about_path)
    end

    scenario 'is impossible if is already created' do
      about_page = FactoryGirl.create(:about)

      visit edit_admin_about_path

      expect(page).not_to have_selector('a.btn', text: 'Create')
    end

    scenario 'it has text that about page is not created yet' do
      visit edit_admin_about_path

      expect(page).to have_selector('h1', text: 'Page is not created yet')
    end

    scenario 'it has a button Create about page if it was not created' do
      visit edit_admin_about_path

      expect(page).to have_selector('a.btn', text: 'Create')
    end

    scenario 'it fails without text' do
      visit edit_admin_about_path
      click_link 'Create'

      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('div.about_text span.help-block', text: "can't be blank")
    end

    scenario 'it succeed with valid text' do
      visit edit_admin_about_path

      click_link 'Create'
      fill_in 'about_text', with: 'there is some text'
      click_button 'Save'

      expect(page).to have_text('About page has been created')
    end
  end

  context 'As an admin I try to update About page' do
    let!(:about_page) { FactoryGirl.create(:about) }
    let(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      log_in_with(admin.email, 'password')
    end

    scenario 'it fails without text' do
      visit edit_admin_about_path

      fill_in 'about_text', with: ''
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('div.about_text span.help-block', text: "can't be blank")
    end

    scenario 'it succeed wit valid text' do
      visit edit_admin_about_path

      fill_in 'about_text', with: 'another valid text'
      click_button 'Save'

      expect(page).to have_text('About page has been updated')
    end
  end

  context 'As an admin I try to delete About page' do
    let!(:about_page) { FactoryGirl.create(:about) }
    let(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      log_in_with(admin.email, 'password')
    end

    scenario 'it succeed' do
      visit edit_admin_about_path

      click_link 'Delete'

      expect(page).to have_text('About page has been deleted')
      expect(page).to have_selector('a.btn', text: 'Create')
    end
  end
end
