require 'rails_helper'

feature 'Navbar' do
  let(:admin) { FactoryGirl.create(:james_bond) }

  describe 'Visitor' do
    scenario 'does not see a link on dashboard' do
      visit root_path

      expect(page).not_to have_selector("a", text: 'Admin')
    end
  end

  describe 'Logged in admin' do
    scenario 'can see a link on dashboard' do
      log_in_with(admin.email, 'password')

      click_link 'Admin'

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_text("Dashboard")
    end
  end
end
