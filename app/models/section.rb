class Section < ApplicationRecord
  attribute :article_id, :integer
  enum section_type: [:text, :image]

  belongs_to :article

  validates :article, presence: true
  validates :text, presence: true, if: :section_type_text?
  validates :image, presence: true, if: :section_type_image?
  has_attached_file :image, styles: { medium: "1280x1280>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image,
                        content_type: /\Aimage\/.*\z/,
                             message: "Invalid content type."

  def section_type_text?
    true if self.section_type == 'text'
  end

  def section_type_image?
    true if self.section_type == 'image'
  end
end
