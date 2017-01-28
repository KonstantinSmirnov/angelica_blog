class ContactForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :name, :message
  validates :email, :name, :message, presence: true
  validates_format_of :email,
                      :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
                      :message => 'email format is invalid'


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
