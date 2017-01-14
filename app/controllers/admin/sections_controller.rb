class Admin::SectionsController < AdminController
  def new
    @article = Article.find(params[:article_id])
    @section = @article.sections.new

    respond_to do |format|
      format.js { render 'new', locals: { article: @article } }
    end
  end
end
