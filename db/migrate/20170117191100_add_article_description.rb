class AddArticleDescription < ActiveRecord::Migration[5.0]
  def up
    add_column :articles, :description, :text
    Article.all.each do |article|
      article.description = 'This is a demo description'
    end
  end

  def down
    remove_column :articles, :description
  end
end
