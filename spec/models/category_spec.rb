require 'rails_helper'

RSpec.describe Category, type: :model do

  it 'has a valid factory' do
    category = FactoryGirl.create(:category, name: 'Category')

    expect(category.name).to eq('Category')
    expect(category.slug).to eq('category')

    # it does not work sd validation includes custom validation
    # which checks if this slug already was used, but in fact it
    # was used already in this category (another words, with
    #validation it checks if can create another category with such attributes):
    # expect(category).to be_valid
  end

  context 'create new category' do
    it 'is invalid without name' do
      category = Category.create(name: '')

      expect(category).to be_invalid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'is valid with name' do
      category = Category.create(name: 'Test name')

      expect(category.name).to eq('Test name')
      expect(category.slug).to eq('test-name')
    end

    it 'is invalid with already existing name' do
      category_one = Category.create(name: 'Test name')
      category_two = Category.create(name: 'Test name')

      expect(category_two).not_to be_valid
      expect(category_two.errors[:name]).to include("has already been taken")
    end

    it 'is invalid with name duplicating slug' do
      category_one = Category.create(name: 'Test name')
      category_two = Category.create(name: 'teST name')

      expect(category_two.errors[:name]).to include('has already been taken')
    end

    it 'has a default slug' do
      category = FactoryGirl.create(:category, name: 'There is a test name')

      expect(category.name).to eq('There is a test name')
      expect(category.slug).to eq('there-is-a-test-name')
    end
  end

  context 'update category' do
    it 'is invalid with empty name' do
      category = FactoryGirl.create(:category)

      category.name = ''
      category.save

      expect(category).to be_invalid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'is valid with new name' do
      category = FactoryGirl.create(:category)

      new_name = 'There is another name'
      category.name = new_name
      category.save

      expect(category.name).to eq(new_name)
      expect(category.slug).to eq('there-is-another-name')
    end

    it 'is invalid with already existing name' do
      category_one = FactoryGirl.create(:category)

      category_two = FactoryGirl.build(:category, name: category_one.name)

      expect(category_two).not_to be_valid
      expect(category_two.errors[:name]).to include('has already been taken')
    end

    it 'is invalid with name which duplcicates slug' do
      category_one = FactoryGirl.create(:category, name: 'Travel')
      category_two = FactoryGirl.create(:category, name: 'Photo')

      category_two.name = 'tRavel'
      category_two.save

      expect(category_two.errors[:name]).to include('has already been taken')
    end

  end

  context 'delete category' do

  end
end
