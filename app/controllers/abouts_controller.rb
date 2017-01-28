class AboutsController < ApplicationController
  def show
    unless @about_page = About.first
      raise ActiveRecord::RecordNotFound
    end
  end
end
