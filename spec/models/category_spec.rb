require 'rails_helper'

RSpec.describe Category, type: :model do

  it 'has a valid factory' do
    category = FactoryGirl.create(:category)

    expect(category).to be_valid
  end

  context 'create new category' do
    it 'is invalid without name' do
      category = Category.create(name: '')

      expect(category).to be_invalid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'is valid with name' do
      category = Category.create(name: 'Test name')

      expect(category).to be_valid
    end

    it 'is invalid with already existing name' do
      category_one = Category.create(name: 'Test name')
      category_two = Category.create(name: 'Test name')

      expect(category_two).not_to be_valid
      expect(category_two.errors[:name]).to include("has already been taken")
    end

    it 'has a default slug' do
      category = FactoryGirl.create(:category, name: 'There is a test name')

      expect(category).to be_valid
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

      expect(category).to be_valid
      expect(category.name).to eq(new_name)
      expect(category.slug).to eq('there-is-another-name')
    end

    it 'is invalid with already existing name' do
      category_one = FactoryGirl.create(:category)

      category_two = FactoryGirl.build(:category, name: category_one.name)

      expect(category_two).not_to be_valid
      expect(category_two.errors[:name]).to include('has already been taken')
    end


  end

  context 'delete category' do

  end
end
