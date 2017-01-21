class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :initialize_app

  def initialize_app
    @categories = Category.all
  end
end
