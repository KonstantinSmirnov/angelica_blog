class Section < ApplicationRecord
  attribute :article_id, :integer

  belongs_to :article

  validates :article, presence: true
  validates :text, presence: true
end
