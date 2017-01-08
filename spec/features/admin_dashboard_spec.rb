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
    end
    scenario 'responds to dashboard_path' do
      visit admin_dashboard_path

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_text("Dashboard")
    end
  end

end
