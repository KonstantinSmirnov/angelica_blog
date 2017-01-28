require 'rails_helper'

feature 'SITEMAP' do
  let!(:article) { FactoryGirl.create(:article) }

  context 'visit /sitemap/xml' do
    scenario 'I can not see link on not published article' do
      visit '/sitemap.xml'

      expect(page).not_to have_text(article.slug)
    end

    scenario 'I can see link on published article' do
      article.published!

      visit '/sitemap.xml'

      expect(page).to have_text(article.slug)
    end

    scenario 'I can not see a link on About page if not created' do
      visit '/sitemap.xml'

      expect(page).not_to have_text('/about')
    end

    scenario 'I can see a link on created About page' do
      about_page = FactoryGirl.create(:about)

      visit '/sitemap.xml'

      expect(page).to have_text('/about')
    end
  end
end
