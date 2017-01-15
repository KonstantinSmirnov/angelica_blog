class Admin::ArticlesController < AdminController
  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash.now[:notice] = "Article has been created"
      render action: 'edit'
    else
      render action: 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(article_params)
      flash.now[:success] = 'Article has been updated'
      render action: 'edit'
    else
      render action: 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])

    @article.destroy
    flash[:success] = 'Article has been deleted'
    redirect_to admin_articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :status, :content,
                    :sections_attributes => [:id, :text, :_destroy, :section_type, :image])
  end
end
