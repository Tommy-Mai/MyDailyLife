# Preview all emails at http://localhost:3000/rails/mailers/inquiry
class InquiryPreview < ActionMailer::Preview
  def inquiry
    InquiryMailer.with(name: "テスト", email: 'test@example.com', contents: "問い合わせメッセージ").creation_inquiry.deliver
  end
end
