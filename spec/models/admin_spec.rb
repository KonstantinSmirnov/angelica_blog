require 'rails_helper'

RSpec.describe Admin, type: :model do
  it 'is invalid without email' do
    admin = Admin.create(
      password: 'password',
      password_confirmation: 'password'
    )

    expect(admin).not_to be_valid
    expect(admin.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    admin = Admin.create(email: 'james_bond@example.com')

    expect(admin).not_to be_valid
    expect(admin.errors[:password]).to include("is too short (minimum is 3 characters)")
  end

  it 'is invalid without a password confirmation' do
    admin = Admin.create(
      email: 'james_bond@example.com',
      password: 'password'
    )

    expect(admin).not_to be_valid
    expect(admin.errors[:password_confirmation]).to include("can't be blank")
  end

  it 'is invalid if password and password confirmation do not match' do
    admin = Admin.create(
      email: 'james_bond@example.com',
      password: 'password',
      password_confirmation: 'another_password'
    )

    expect(admin).not_to be_valid
    expect(admin.errors[:password_confirmation]).to include("doesn't match Password")
  end

  it 'is invalid if duplicates email address' do
    first_admin = FactoryGirl.create(:james_bond)
    second_admin = Admin.create(
      email: first_admin.email,
      password: 'password',
      password_confirmation: 'password'
    )

    expect(second_admin).not_to be_valid
    expect(second_admin.errors[:email]).to include("has already been taken")
  end

  it 'is invalid if password does not contain symbols' do
    
  end

  it 'is valid with email, password and password confirmation' do
    admin = FactoryGirl.create(:james_bond)

    expect(admin).to be_valid
  end

  describe 'Update' do
    it 'changes the password if we provide new password' do
      admin = FactoryGirl.create(:james_bond)

      crypted_password = admin.crypted_password
      expect(admin.crypted_password).to eq(crypted_password)

      admin.password = 'new_password'
      admin.password_confirmation = 'new_password'
      admin.save

      expect(admin.crypted_password).not_to eq(crypted_password)
    end

    it 'is invalid without password confirmation' do
      admin = FactoryGirl.create(:james_bond)

      admin.password = 'new_password'
      admin.save

      expect(admin).not_to be_valid
      expect(admin.errors[:password_confirmation]).to include("can't be blank")
    end

    it 'is invalid if password and password confirmation do not match' do
      admin = FactoryGirl.create(:james_bond)

      admin.password = 'password'
      admin.password_confirmation = 'another_password'
      admin.save

      expect(admin).not_to be_valid
      expect(admin.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end
