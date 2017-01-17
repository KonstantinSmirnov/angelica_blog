class Article < ApplicationRecord
  enum status: [:draft, :published]
  has_many :sections, dependent: :destroy

  validates :title, presence: true
  validates :cover_image, presence: true
  has_attached_file :cover_image, styles: { medium: "300x300>", thumb: "100x100>"}, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :cover_image,
                              content_type: /\Aimage\/.*\z/,
                              message: 'Invalid content type.'

  accepts_nested_attributes_for :sections,
                      allow_destroy: true
end
