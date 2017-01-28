class SitemapController < ApplicationController
  def show
    @published_articles = Article.published
    @about_page = About.first
    respond_to do |format|
      format.xml
    end
  end
end
