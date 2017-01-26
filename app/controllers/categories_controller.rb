class CategoriesController < ApplicationController
  def show
    if @category = Category.find_by_slug(params[:id])
      @published_articles = Article.where(category: Category.find_by_slug(params[:id])).published.order(created_at: :desc)
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
