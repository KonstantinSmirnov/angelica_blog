class Admin::SectionsController < AdminController
  def new
    @article = Article.find(params[:article_id])
    # @section = @article.sections.new(section_type: params[:section_type])

    respond_to do |format|
      format.js { render 'new', locals: { article: @article } }
    end
  end
end
