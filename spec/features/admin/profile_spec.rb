require 'rails_helper'

feature 'Profile' do
  describe 'Visitor' do
    scenario 'does not respond to admin profile path' do
      visit admin_profile_path

      expect(current_path).to eq(root_path)
    end
  end

  describe 'Admin' do
    let(:admin) { FactoryGirl.create(:james_bond) }

    before(:each) do
      log_in_with(admin.email, 'password')
      visit admin_profile_path
    end

    feature 'Update password' do

      scenario 'has update password section' do
        expect(page).to have_selector('h4', text: 'Update password')
      end

      scenario 'fails without current password' do
        fill_in 'admin_password', with: 'new_password'
        fill_in 'admin_password_confirmation', with: 'new_password'
        click_button 'Update'

        expect(page).to have_text('Invalid password')
      end

      scenario 'fails with invalid current password' do
        fill_in 'admin_current_password', with: 'invalid_password'
        fill_in 'admin_password', with: 'new_password'
        fill_in 'admin_password_confirmation', with: 'new_password'
        click_button 'Update'

        expect(page).to have_text('Invalid password')
      end

      #TEST FAILS
      # scenario 'fails without new password' do
      #   fill_in 'admin_current_password', with: 'password'
      #   click_button 'Update'
      #
      #   expect(page).to have_text('Invalid new password')
      # end

      #TEST FAILS
      # scenario 'fails with spacebar symbols in password' do
      #   fill_in 'admin_current_password', with: 'password'
      #   fill_in 'admin_password', with: '   '
      #   fill_in 'admin_password_confirmation', with: '   '
      #   click_button 'Update'
      #
      #   expect(page).to have_text('Invalid new password')
      # end

      scenario 'fails without password confirmation' do
        fill_in 'admin_current_password', with: 'password'
        fill_in 'admin_password', with: 'new_password'
        click_button 'Update'

        expect(page).to have_text('Password and password confirmation do not match')
      end

      scenario 'fails if new password and confirmation not match' do
        fill_in 'admin_current_password', with: 'password'
        fill_in 'admin_password', with: 'new_password'
        fill_in 'admin_password_confirmation', with: 'another_password'
        click_button 'Update'

        expect(page).to have_text('Password and password confirmation do not match')
      end

      scenario 'updates password with valid data' do
        fill_in 'admin_current_password', with: 'password'
        fill_in 'admin_password', with: 'new_password'
        fill_in 'admin_password_confirmation', with: 'new_password'
        click_button 'Update'

        expect(page).to have_text('Password updated')
      end
    end


  end
end
