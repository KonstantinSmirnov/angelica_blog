require 'rails_helper'

feature 'CATEGORY' do

  context 'As a visitor' do
    scenario 'I can see created category in navbar' do
      category = FactoryGirl.create(:category, name: 'Travel')

      visit root_path

      expect(page).to have_selector('nav.navbar a.nav-link', text: category.name)
    end
  end

  context 'As an admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:category) { FactoryGirl.create(:category) }

    before(:each) do
      log_in_with(admin.email, 'password')
    end

    context 'I want to add new category' do
      scenario 'it fails without name' do
        visit admin_categories_path
        click_link 'Add'

        fill_in 'category_name', with: ''
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.category_name span.help-block', text: "can't be blank")
      end

      scenario 'it fails with already taken name' do
        category = FactoryGirl.create(:category, name: 'Already existing name')
        visit new_admin_category_path

        fill_in 'category_name', with: category.name
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.category_name span.help-block', text: 'has already been taken')

      end

      scenario 'it succeed with a valid name' do
        visit new_admin_category_path

        fill_in 'category_name', with: 'There is a test name'
        click_button 'Save'

        expect(page).to have_text('Category has been created')
        expect(current_path).to include('there-is-a-test-name')
      end

    end

    context 'I want to update a category' do

      before(:each) do
        category = FactoryGirl.create(:category, name: 'Update category')
        another_category = FactoryGirl.create(:category, name: 'Existing category')
        visit edit_admin_category_path(category)
      end

      scenario 'it fails with empty name' do
        fill_in 'category_name', with: ''
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.category_name span.help-block', text: "can't be blank")
      end

      scenario 'it fails with already taken name' do
        fill_in 'category_name', with: 'Existing category'
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.category_name span.help-block', text: 'has already been taken')
      end

      scenario 'it fails if name duplicates existing slug' do
        fill_in 'category_name', with: 'existing catEgory'
        click_button 'Save'

        expect(page).to have_text('Please review the problems below')
        expect(page).to have_selector('div.category_name span.help-block', text: 'has already been taken')
      end

      scenario 'it succeed with a valid name' do
        fill_in 'category_name', with: 'Another category name'
        click_button 'Save'

        expect(page).to have_text('Category has been updated')
      end
    end

    context 'I want to delete a category' do
      scenario 'is deleted' do
        category = FactoryGirl.create(:category)
        visit edit_admin_category_path(category)

        click_link 'Delete'

        expect(page).to have_text('Category has been deleted')
      end
    end
  end
end
