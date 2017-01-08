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
      expect(page).to have_selector("h1", text: 'Articles')
    end
  end
end
