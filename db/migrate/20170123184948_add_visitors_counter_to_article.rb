class AddVisitorsCounterToArticle < ActiveRecord::Migration[5.0]
  def up
    add_column :articles, :views, :integer, default: 0
  end

  def down
    remove_column :articles, :views
  end
end
