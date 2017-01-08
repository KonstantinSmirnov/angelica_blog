require 'rails_helper'

feature 'Admin logs in' do
  before(:each) do
    visit login_path
  end

  scenario 'responds to login path' do
    expect(current_path).to eq(login_path)
    expect(page).to have_selector('h1', text: 'Log in')
  end

  scenario 'fails without email' do
    fill_in 'admin_password', with: 'password'
    click_button 'Log in'

    expect(page).to have_text('Invalid email or password')
  end

  scenario 'fails without password' do
    fill_in 'admin_email', with: 'james_bond@example.com'
    click_button 'Log in'

    expect(page).to have_text('Invalid email or password')
  end

  scenario 'fails with invalid email' do
    fill_in 'admin_email', with: 'invalid_email'
    fill_in 'admin_password', with: 'password'
    click_button 'Log in'

    expect(page).to have_text('Invalid email or password')
  end

  scenario 'logs in with valid email and password' do
    admin = FactoryGirl.create(:james_bond)

    visit login_path

    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: 'password'
    click_button 'Log in'

    expect(current_path).to eq(root_path)
    expect(page).to have_text("Login successful")
  end
end
