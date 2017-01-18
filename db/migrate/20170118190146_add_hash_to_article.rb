class AddHashToArticle < ActiveRecord::Migration[5.0]
  require 'securerandom'

  def up
    add_column :articles, :article_hash, :string
    Article.all.each do |article|
      article.article_hash = SecureRandom.hex(3)
      article.save
    end
  end

  def down
    remove_column :articles, :article_hash
  end
end
