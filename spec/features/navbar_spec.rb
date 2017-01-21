require 'rails_helper'

feature 'Navbar' do
  let(:admin) { FactoryGirl.create(:james_bond) }

  context 'As a visitor' do
    scenario 'I do not not see a link on dashboard' do
      visit root_path

      expect(page).not_to have_selector("a", text: 'Admin')
    end

  end

  context 'As an admin' do
    scenario 'I can see a link on dashboard' do
      log_in_with(admin.email, 'password')

      click_link 'Admin'

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_text("Dashboard")
      expect(page).to have_selector('a.active', text: 'Admin')
    end

  end
end
