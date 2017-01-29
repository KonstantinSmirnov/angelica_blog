require 'rails_helper'

feature 'ROBOTS.TXT' do
  context 'visit /robots.txt' do
    scenario 'it allows all except /admin/ for search engines' do
      visit '/robots.txt'

      expect(page).to have_text('User-agent: * Allow: / Disallow: /admin/')
    end
  end
end
