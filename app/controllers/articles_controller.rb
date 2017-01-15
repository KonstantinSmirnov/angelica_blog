class ArticlesController < ApplicationController
  def index
    @published_articles = Article.published
  end
end
