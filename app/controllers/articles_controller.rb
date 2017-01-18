class ArticlesController < ApplicationController
  def index
    @published_articles = Article.published
  end

  def show
    @article = Article.find_by_slug(params[:id])
  end
end
