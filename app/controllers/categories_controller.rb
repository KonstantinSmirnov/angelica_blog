class CategoriesController < ApplicationController
  def show
    @published_articles = Article.where(category: Category.find_by_slug(params[:id])).published.order(created_at: :desc)
  end
end
