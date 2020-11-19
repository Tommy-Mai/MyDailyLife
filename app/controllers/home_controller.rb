# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :login_required

  def top
    redirect_to user_path(session[:user_id]) if session[:user_id]
  end

  def about; end

  def policy; end

  def contact; end

  def faqs; end
end
