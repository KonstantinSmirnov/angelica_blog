class Category < ApplicationRecord
  require 'translit'

  has_many :articles

  validates :name, presence: true
  validates :name, uniqueness: true

  validate :name_does_not_generate_existing_slug

  # to check that new name does not create duplicating slug
  # validates_each :name do |record, attr, value|
  #   slug = Translit.convert(value, :english).downcase.gsub(/[^0-9a-z]/i, '-')
  #   p "!!!!!!!!!!!!!!! #{self.methods}"
  #   record.errors.add(attr, 'has already been taken') if Category.find_by_slug(slug)
  # end

  def name_does_not_generate_existing_slug
    slug = Translit.convert(self.name, :english).downcase.gsub(/[^0-9a-z]/i, '-')
    category = Category.find(self.id) if self.id
    unless category
      errors.add(:name, 'has already been taken') if Category.find_by_slug(slug)
    else
      if category.slug != slug
        errors.add(:name, 'has already been taken') if Category.find_by_slug(slug)
      end
    end

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
