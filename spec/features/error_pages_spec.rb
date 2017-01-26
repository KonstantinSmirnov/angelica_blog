require 'rails_helper'

feature 'ERROR PAGES' do
  let(:not_published_article) { FactoryGirl.create(:article, status: 'draft') }
  let(:category) { FactoryGirl.create(:category) }

  context 'I will see 404 page if visit' do
    scenario 'inexistent article' do
      visit '/articles/inexistent-article'

      expect(page).to have_selector('h1', text: '404 page')
    end

    scenario 'not published article url' do
      visit article_path(not_published_article)

      expect(page).to have_selector('h1', text: '404 page')
    end

    scenario 'partially matching article url' do
      article = FactoryGirl.create(:article)
      article.published!

      visit "/articles/#{article.slug}"[0...-3]

      expect(page).to have_selector('h1', text: '404 page')
    end

    scenario 'inexistent url' do
      visit '/inexistent-url'

      expect(page).to have_selector('h1', text: '404 page')
    end

    scenario 'inexistent category' do
      visit '/categories/inexistent-category'

      expect(page).to have_selector('h1', text: '404 page')
    end

    scenario 'partially matched category url' do
      category = FactoryGirl.create(:category)

      visit "/categories/#{category.slug}"[0...-3]

      expect(page).to have_selector('h1', text: '404 page')
    end

    scenario '/404' do
      visit '/404'

      expect(page).to have_selector('h1', text: '404 page')
    end
  end

  context 'I will see 500 page if I visit' do
    scenario '/500' do
      visit '/500'

      expect(page).to have_selector('h1', text: '500 page')
    end
  end

  context 'On 404 page I see' do
    scenario "header '404 page'" do
      visit '/404'

      expect(page).to have_selector('h1', text: '404 page')
    end
  end

  context 'On 500 page I see' do
    scenario "header '500 page'" do
      visit '/500'

      expect(page).to have_selector('h1', text: '500 page')
    end
  end
end
