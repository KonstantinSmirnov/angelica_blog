class AddImageToAboutPage < ActiveRecord::Migration[5.0]
  def up
    add_attachment :abouts, :image
  end

  def down
    remove_attachment :abouts, :image
  end
end
