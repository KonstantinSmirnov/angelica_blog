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
      mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
      admin = Admin.first
      message_params = {
        from: ENV['LETTER_FROM'],
        to: admin.email,
        subject: "A letter from Peanut page",
        text:
        "From: #{params[:contact_form][:name]}\n
        Email: #{params[:contact_form][:email]}\n
        Message: #{params[:contact_form][:message]}"
      }
      if mg_client.send_message ENV['DOMAIN'], message_params
        flash[:success] = 'Your message has been sent'
        redirect_to about_path
      else
        flash[:notice] = 'Your email was not sent. Please try again'
        render 'show'
      end
    else
      render 'show'
    end
  end

  private

  def letter_params
    params.require(:contact_form).permit(:email, :name, :message)
  end
end
