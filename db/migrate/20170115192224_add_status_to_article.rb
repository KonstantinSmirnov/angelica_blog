class AddStatusToArticle < ActiveRecord::Migration[5.0]
  def up
    add_column :articles, :status, :integer, default: 0
    Article.all.each { |a| a.draft! }
  end

  def down
    remove_column :articles, :status
  end
end
