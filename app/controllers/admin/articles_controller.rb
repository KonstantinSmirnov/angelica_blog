class Admin::ArticlesController < AdminController
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:notice] = "Article has been created"
      redirect_to edit_admin_article_path(@article)
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find_by_slug(params[:id])
  end

  def update
    @article = Article.find_by_slug(params[:id])

    if @article.update_attributes(article_params)
      flash[:success] = 'Article has been updated'
      redirect_to edit_admin_article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find_by_slug(params[:id])

    @article.destroy
    flash[:success] = 'Article has been deleted'
    redirect_to admin_articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :category_id, :status, :cover_image, :description, :content,
                    :sections_attributes => [:id, :text, :_destroy, :section_type, :image])
  end
end
