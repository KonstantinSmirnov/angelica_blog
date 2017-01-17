class ArticlesController < ApplicationController
  def index
    @published_articles = Article.published
  end

  def show
    @article = Article.find(params[:id])
  end
end
