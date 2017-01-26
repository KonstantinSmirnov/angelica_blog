class AddPublicationDateToArticle < ActiveRecord::Migration[5.0]
  def up
    add_column :articles, :published_at, :datetime
    Article.published.each do |a|
      a.published_at = a.created_at
      a.save!
    end
  end

  def down
    remove_column :articles, :published_at
  end
end
