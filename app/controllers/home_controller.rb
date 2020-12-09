# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :login_required
  skip_before_action :time_out, only: [:top]

  def top
    redirect_to user_path(session[:user_id]) if session[:user_id]
  end

  def send_inquiry
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.valid?
      InquiryMailer.with(name: @inquiry.name, email: @inquiry.email, contents: @inquiry.contents, user_id: @inquiry.user_id).creation_inquiry.deliver_later
      redirect_back(fallback_location: root_path)
      flash[:notice] = "お問い合わせを送信しました。お問い合わせいただきありがとうございます。"
    else
      redirect_back(fallback_location: root_path)
      flash[:notice] = "お問い合わせの送信に失敗しました。入力内容をご確認の上、時間をおいて再度お試しください。"
    end
  end

  def about; end

  def policy; end

  def contact; end

  def faqs; end

  private

  def inquiry_params
    if current_user.nil?
      params.require(:inquiry).permit(:name, :email, :message, :contents)
    else
      params.require(:inquiry).permit(:name, :email, :message, :contents).merge(user_id: current_user.id)
    end
  end
  
end
