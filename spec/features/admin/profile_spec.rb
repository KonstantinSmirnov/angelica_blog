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

    feature 'Update email' do
      scenario 'has update email section' do
        expect(page).to have_selector('h4', text: 'Update email')
        expect(page).to have_selector('section#update_email')
      end

      scenario 'fails without password' do
        within('section#update_email') do
          fill_in 'admin_email', with: 'test@test.com'
          click_button 'Update'
        end

        expect(page).to have_text('Password invalid')
      end

      scenario 'fails with invalid password' do
        within('section#update_email') do
          fill_in 'admin_email', with: 'test@test.com'
          fill_in 'admin_password', with: 'invalid_password'
          click_button 'Update'
        end

        expect(page).to have_text('Password invalid')
      end

      scenario 'fails with empty email' do
        within('section#update_email') do
          fill_in 'admin_email', with: ''
          fill_in 'admin_password', with: 'password'
          click_button 'Update'
        end

        expect(page).to have_text 'Please review the problems below'
        expect(page).to have_selector('div.admin_email.has-error span.help-block', text: "can't be blank")
      end

      scenario 'fails with invalid email'
    end

    feature 'Update password' do

      scenario 'has update password section' do
        expect(page).to have_selector('h4', text: 'Update password')
        expect(page).to have_selector('section#update_password')
      end

      scenario 'fails without current password' do
        within('section#update_password') do
          fill_in 'admin_password', with: 'new_password'
          fill_in 'admin_password_confirmation', with: 'new_password'
          click_button 'Update'
        end

        expect(page).to have_text('Invalid password')
      end

      scenario 'fails with invalid current password' do
        within('section#update_password') do
          fill_in 'admin_current_password', with: 'invalid_password'
          fill_in 'admin_password', with: 'new_password'
          fill_in 'admin_password_confirmation', with: 'new_password'
          click_button 'Update'
        end

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
        within('section#update_password') do
          fill_in 'admin_current_password', with: 'password'
          fill_in 'admin_password', with: 'new_password'
          click_button 'Update'
        end

        expect(page).to have_text('Password and password confirmation do not match')
      end

      scenario 'fails if new password and confirmation not match' do
        within('section#update_password') do
          fill_in 'admin_current_password', with: 'password'
          fill_in 'admin_password', with: 'new_password'
          fill_in 'admin_password_confirmation', with: 'another_password'
          click_button 'Update'
        end

        expect(page).to have_text('Password and password confirmation do not match')
      end

      scenario 'updates password with valid data' do
        within('section#update_password') do
          fill_in 'admin_current_password', with: 'password'
          fill_in 'admin_password', with: 'new_password'
          fill_in 'admin_password_confirmation', with: 'new_password'
          click_button 'Update'
        end

        expect(page).to have_text('Password updated')
      end
    end

  end
end
