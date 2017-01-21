class AddCategoryToArticle < ActiveRecord::Migration[5.0]
  def up
    add_column :articles, :category_id, :integer
  end

  def down
    remove_column :articles, :category_id
  end
end
