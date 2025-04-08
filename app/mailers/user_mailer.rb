class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @url = "http://localhost:3000/login"
    mail(to: @user.email, subject: "Welcome to OdinBook")
  end
end
