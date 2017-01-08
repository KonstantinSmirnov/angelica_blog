class SessionsController < ApplicationController
  def new
    @admin = Admin.new
  end

  def create
    if @admin = login(params[:admin][:email], params[:admin][:password])
      redirect_back_or_to root_path, notice: 'Login successful'
    else
      @admin = Admin.new
      flash.now[:alert] = 'Invalid email or password'
      render action: 'new'
    end
  end
end
