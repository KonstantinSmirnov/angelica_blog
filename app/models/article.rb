class Article < ApplicationRecord
  require 'translit'
  require 'securerandom'

  attribute :published_at, :datetime

  enum status: [:draft, :published]
  has_many :sections, dependent: :destroy
  belongs_to :category

  validates :title, presence: true
  validates :cover_image, presence: true
  validates :description, presence: true
  validates :slug, presence: true
  validates :slug, uniqueness: true

  has_attached_file :cover_image, styles: { big: "1500x1500>", medium: "600x600>", thumb: "100x100>"}, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :cover_image,
                              content_type: /\Aimage\/.*\z/,
                              message: 'Invalid content type.'

  accepts_nested_attributes_for :sections,
                      allow_destroy: true

  before_validation do
    #create slug
    self.article_hash = SecureRandom.hex(3) unless self.article_hash
    self.slug = Translit.convert(self.title, :english)
    self.slug = self.slug.downcase.gsub(/[^0-9a-z]/i, '-') + '-' + self.article_hash

    #update publication date
    if self.published?
      self.published_at = DateTime.now if self.published_at == nil
    else
      self.published_at = nil
    end
  end

  def to_param
    slug
  end
end
