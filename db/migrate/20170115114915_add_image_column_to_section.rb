class AddImageColumnToSection < ActiveRecord::Migration[5.0]
  def up
    add_column :sections, :image_uid,  :string
  end

  def down
    remove_column :sections, :image_uid 
  end
end
