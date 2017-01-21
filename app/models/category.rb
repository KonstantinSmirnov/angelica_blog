class Category < ApplicationRecord
  require 'translit'

  validates :name, presence: true
  validates :name, uniqueness: true

  before_validation do
    self.slug = Translit.convert(self.name, :english)
    self.slug = self.slug.downcase.gsub(/[^0-9a-z]/i, '-')
  end
end
