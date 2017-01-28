class AboutsController < ApplicationController
  def show
    if @about_page = About.first
      @contact_form = ContactForm.new
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def send_letter
    @contact_form = ContactForm.new(letter_params)
    if @contact_form.valid?
      flash[:success] = 'Your message has been sent'
      redirect_to about_path
    else
      render 'show'
    end
  end

  private

  def letter_params
    params.require(:contact_form).permit(:email, :name, :message)
  end
end
