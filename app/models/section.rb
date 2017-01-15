class Section < ApplicationRecord
  attribute :article_id, :integer
  enum section_type: [:text, :image]

  belongs_to :article

  validates :article, presence: true
  validates :text, presence: true #, :unless => :section_type.text?
end
