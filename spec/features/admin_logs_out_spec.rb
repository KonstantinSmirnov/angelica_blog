require 'rails_helper'

feature 'Admin logs out' do
  scenario 'logs out' do
    admin = FactoryGirl.create(:james_bond)

    log_in_with(admin.email, 'password')

    click_link 'Log out'

    expect(current_path).to eq(login_path)
    expect(page).to have_text('Logged out successfully')
  end
end
