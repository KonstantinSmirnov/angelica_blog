require 'rails_helper'

feature 'ABOUT PAGE' do

  context 'As a visitor I go to About page' do
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

    context 'it has About me section' do
      let!(:about_page) { FactoryGirl.create(:about) }

      scenario 'has image' do
        visit '/about'

        expect(page).to have_css("img[src*='#{about_page.image.url(:medium)}']")
      end
      scenario 'has text' do
        visit '/about'

        expect(page).to have_text(about_page.text)
      end
    end

    context 'can send a email' do
      let!(:about_page) { FactoryGirl.create(:about) }
      let!(:admin) { FactoryGirl.create(:admin, email: 'k.smi@mail.ru') }

      before(:each) do
        visit '/about'
      end

      scenario 'Has Contact me title' do
        expect(page).to have_selector('h1', text: 'Write a letter')
      end

      scenario 'succeeed with valid data' do
        fill_in 'contact_form_email', with: 'test@test.com'
        fill_in 'contact_form_name', with: 'Test user'
        fill_in 'contact_form_message', with: 'there is a test message'
        click_button 'Submit'

        expect(page).to have_text('Your message has been sent')
      end
      scenario 'fails without email' do
        fill_in 'contact_form_email', with: '  '
        fill_in 'contact_form_name', with: 'Test user'
        fill_in 'contact_form_message', with: 'There is a test message'
        click_button 'Submit'

        expect(page).to have_selector('div.contact_form_email span.help-block', text: "can't be blank")
      end
      scenario 'fails with invalid email' do
        fill_in 'contact_form_email', with: 'test@te@st.com'
        fill_in 'contact_form_name', with: 'User name'
        fill_in 'contact_form_message', with: 'There is a test message'
        click_button 'Submit'

        expect(page).to have_selector('div.contact_form_email span.help-block', text: "email format is invalid")
      end
      scenario 'fails without name' do
        fill_in 'contact_form_email', with: 'test@test.com'
        fill_in 'contact_form_name', with: '   '
        fill_in 'contact_form_message', with: 'There is a test message'
        click_button 'Submit'

        expect(page).to have_selector('div.contact_form_name span.help-block', text: "can't be blank")
      end
      scenario 'fails without message' do
        fill_in 'contact_form_email', with: 'test@test.com'
        fill_in 'contact_form_name', with: 'Test user'
        fill_in 'contact_form_message', with: '   '
        click_button 'Submit'

        expect(page).to have_selector('div.contact_form_message span.help-block', text: "can't be blank")
      end
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

      attach_file('Image', Rails.root + "spec/fixtures/images/test_image.png")
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('div.about_text span.help-block', text: "can't be blank")
    end

    scenario 'it fails without image' do
      visit edit_admin_about_path

      click_link 'Create'
      fill_in 'about_text', with: 'there is some text'
      click_button 'Save'

      expect(page).to have_text('Please review the problems below')
      expect(page).to have_selector('div.about_image span.help-block', text: "can't be blank")
    end

    scenario 'it succeed with valid text and image' do
      visit edit_admin_about_path

      click_link 'Create'
      fill_in 'about_text', with: 'there is some text'
      attach_file('Image', Rails.root + "spec/fixtures/images/test_image.png")
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
