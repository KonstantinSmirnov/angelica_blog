class Category < ApplicationRecord
  require 'translit'

  validates :name, presence: true
  validates :name, uniqueness: true
  
  # to check that new name does ot create duplicating slug
  validates_each :name do |record, attr, value|
    slug = Translit.convert(value, :english).downcase.gsub(/[^0-9a-z]/i, '-')
    record.errors.add(attr, 'has already been taken') if Category.find_by_slug(slug)
  end

  before_update do
    self.slug = Translit.convert(self.name, :english)
    self.slug = self.slug.downcase.gsub(/[^0-9a-z]/i, '-')
  end

  before_create do
    self.slug = Translit.convert(self.name, :english)
    self.slug = self.slug.downcase.gsub(/[^0-9a-z]/i, '-')
  end

  def to_param
    slug
  end

end
