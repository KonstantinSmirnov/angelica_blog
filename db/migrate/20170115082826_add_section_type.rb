class AddSectionType < ActiveRecord::Migration[5.0]
  def up
    add_column :sections, :section_type, :integer
    Section.all.each do |section|
      section.text!
    end
  end

  def down
    remove_column :sections, :section_type
  end
end
