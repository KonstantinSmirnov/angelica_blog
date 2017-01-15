require 'rails_helper'

feature 'Dashboard' do

  describe 'Visitor' do
    scenario 'does not respond to dashboard_path if admin is not logged in' do
      visit admin_dashboard_path

      expect(current_path).to eq(root_path)
    end
  end

  describe 'Admin' do
    let(:admin) { FactoryGirl.create(:james_bond) }

    before(:each) do
      log_in_with(admin.email, 'password')
      visit admin_dashboard_path
    end

    scenario 'responds to dashboard_path' do
      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_text("Dashboard")
    end

    scenario 'has link to dashboard' do
      click_link 'Dashboard'

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_selector('a.active', text: 'Dashboard')
    end

    scenario 'has link to articles list' do
      click_link 'My articles'

      expect(current_path).to eq(admin_articles_path)
      expect(page).to have_selector('a.active', text: 'My articles')
    end

    scenario 'has link to profile' do
      click_link 'Profile'

      expect(current_path).to eq(admin_profile_path)
      expect(page).to have_selector('a.active', text: 'Profile')
    end


    describe 'Dashboard parameters' do

      scenario 'showes published articles count' do
        visit new_admin_article_path

        fill_in 'article_title', with: 'some text'
        click_button 'Save'

        visit admin_dashboard_path

        expect(page).to have_text("Articles 1")
      end
    end

  end

end
