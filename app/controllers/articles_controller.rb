class ArticlesController < ApplicationController
  def index
    @published_articles = Article.published.order(created_at: :desc)
  end

  def show
    @article = Article.find_by_slug(params[:id])
    @article.increment!(:views)
  end
end
