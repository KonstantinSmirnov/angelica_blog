module AuthenticationMacros
  def log_in_with(email, password)
    visit login_path

    fill_in 'admin_email', with: email
    fill_in 'admin_password', with: password

    click_button 'Log in'
  end
end
