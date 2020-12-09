# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'mydailylife@hello.com'
  layout 'mailer'
end
