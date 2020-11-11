class HomeController < ApplicationController
  skip_before_action :login_required
  
  def top
  end

  def about
  end

  def policy
  end

  def contact
  end
  
  def faqs
  end
  
  
end
