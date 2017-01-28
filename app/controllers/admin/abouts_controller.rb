class Admin::AboutsController < AdminController

  def new
    @about_page = About.new
  end

  def create
    @about_page = About.new(about_params)
    if @about_page.save
      flash[:success] = 'About page has been created'
      redirect_to edit_admin_about_path
    else
      render 'new'
    end
  end

  def edit
    @about_page = About.first
  end

  def update
    @about_page = About.first
    if @about_page.update_attributes(about_params)
      flash[:success] = 'About page has been updated'
      redirect_to edit_admin_about_path
    else
      render 'edit'
    end
  end

  def destroy
    @about_page = About.last

    @about_page.destroy
    flash[:success] = 'About page has been deleted'
    redirect_to edit_admin_about_path
  end

  private

  def about_params
    params.require(:about).permit(:text, :image)
  end
end
