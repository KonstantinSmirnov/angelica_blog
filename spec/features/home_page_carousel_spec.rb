require 'rails_helper'

feature 'CAROUSEL' do
  context 'Visitor' do
    scenario 'can not see carousel if is turned off'
    scenario 'can not see carousel if it has no articles'
  end

  context 'Admin' do
    scenario 'can enable and disable component on Home page'
    scenario 'can enable and disable component on Category page'
    scenario 'can add articles'
    scenario 'can not add more than 5 articles'

  end
end
