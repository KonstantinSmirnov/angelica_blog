class Article < ApplicationRecord
  has_many :sections, dependent: :destroy

  validates :title, presence: true
end
