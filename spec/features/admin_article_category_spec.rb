require 'rails_helper'

feature 'ARTICLE' do
  describe 'assign Category' do
    let(:article) { FactoryGirl.create(:article) }

    context 'As a visitor' do
      scenario 'I see published articles in a category' do
        category = FactoryGirl.create(:category)
        article.category = category
        article.published!
        article.save

        visit category_path(category)

        expect(page).to have_text(article.title)
      end
    end

    context 'As an admin' do
      let(:admin) { FactoryGirl.create(:admin) }

      before(:each) do
        log_in_with(admin.email, 'password')
      end

      scenario 'I assign article to category' do
        category = FactoryGirl.create(:category)
        visit edit_admin_article_path(article)

        select category.name, from: 'article_category_id'
        click_button 'Save'

        expect(page).to have_text('Article has been updated')

        visit edit_admin_article_path(article)
        expect(find("#article_category_id").value).to eq("#{category.id}")
      end

      scenario 'I want to keep articles if category removed' do
        category = FactoryGirl.create(:category)
        article.category = category
        article.save

        visit edit_admin_category_path(category)
        click_link 'Delete'

        visit edit_admin_article_path(article)
        expect(find("#article_category_id").value).to eq("")
      end
    end
  end


end
