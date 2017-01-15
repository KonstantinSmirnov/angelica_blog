class Section < ApplicationRecord
  attribute :article_id, :integer
  enum section_type: [:text, :image]

  dragonfly_accessor :image

  belongs_to :article

  validates :article, presence: true
  validates :text, presence: true, if: :section_type_text?
  validates :image, presence: true, if: :section_type_image?
  validates_property :format, of: :image, in: ['jpeg', 'jpg', 'png', 'gif'],
                      message: "the formats allowed are: .jpeg, .jpg, .png, .gif", if: :image_changed?

  def section_type_text?
    true if self.section_type == 'text'
  end

  def section_type_image?
    true if self.section_type == 'image'
  end
end
