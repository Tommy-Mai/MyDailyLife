# frozen_string_literal: true

class InquiryMailer < ApplicationMailer
  def creation_inquiry
    @name = params[:name]
    @email = params[:email]
    @contents = params[:contents]
    @user_id = params[:user_id]
    mail(
      subject: '【MyDailyLife】ユーザーからのお問い合わせ',
      to: ENV['SEND_MAIL'],
      from: ENV['SEND_MAIL']
    )
  end
end
