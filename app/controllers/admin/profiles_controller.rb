class Admin::ProfilesController < AdminController
  def edit
    @admin = Admin.find(current_user.id)
  end

  def update_password
    @admin = Admin.find(current_user.id)
    if @new_admin = login(current_user.email, params[:admin][:current_password])
      if @new_admin.update_attributes(update_password_params)
        flash.now[:success] = 'Password updated'
        render 'edit'
      else
        flash.now[:alert] = 'Password and password confirmation do not match'
        render 'edit'
      end
    else
      flash.now[:alert] = 'Invalid password'
      render 'edit'
    end
  end

  private

  def update_password_params
    params.require(:admin).permit(:password, :password_confirmation)
  end
end
