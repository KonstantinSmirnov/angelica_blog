class Admin::CategoriesController < AdminController
  def index
    @categories = Category.all.order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category has been created"
      redirect_to edit_admin_category_path(@category)
    else
      render action: 'edit'
    end
  end

  def edit
    @category = Category.find_by_slug(params[:id])
  end

  def update
    @category = Category.find_by_slug(params[:id])

    if @category.update_attributes(category_params)
      flash[:success] = "Category has been updated"
      redirect_to edit_admin_category_path(@category)
    else
      render action: 'edit'
    end
  end

  def destroy
    @category = Category.find_by_slug(params[:id])

    @category.destroy
    flash[:success] = 'Category has been deleted'
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
