class AddSlugToArticle < ActiveRecord::Migration[5.0]
  def up
    add_column :articles, :slug, :string
    Article.all.each do |article|
      new_slug = Translit.convert(article.title, :english)
      article.slug = new_slug.downcase.gsub(/[^0-9a-z]/i, '-')
      article.save!
    end
  end

  def down
    remove_column :articles, :slug
  end
end
