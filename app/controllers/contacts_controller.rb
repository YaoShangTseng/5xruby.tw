class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    if @contact.valid? && recaptcha?
      ContactMailer.enquire(@contact).deliver
      redirect_to contacts_path, notice: t('.mail_sent_successfully')
    else
      @contact.errors.add(:base, :captcha_not_passed) unless recaptcha?
      flash.now[:alert] = t('.something_went_wrong')
      render 'pages/contacts'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :message, :price)
  end
end