class Admin::SectionsController < AdminController
  def new
    @article = Article.find_by_slug(params[:article_id])
    # @section = @article.sections.new(section_type: params[:section_type])

    respond_to do |format|
      format.js { render 'new', locals: { article: @article } }
    end
  end
end
