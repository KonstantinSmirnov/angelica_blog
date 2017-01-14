class Article < ApplicationRecord
  has_many :sections, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :sections,
                      allow_destroy: true
end
