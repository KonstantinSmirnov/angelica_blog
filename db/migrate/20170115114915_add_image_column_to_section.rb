class AddImageColumnToSection < ActiveRecord::Migration[5.0]
  def up
    add_attachment :sections, :image
  end

  def down
    remove_attachment :sections, :image
  end
end
