class ArticlesController < ApplicationController
  def index
    @published_articles = Article.published.order(created_at: :desc)
  end

  def show
    if @article = Article.published.find_by_slug(params[:id])
      @article.increment!(:views)
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
