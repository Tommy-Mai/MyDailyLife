require "rails_helper"

RSpec.describe InquiryMailer, type: :mailer do
  # user_id有
  let(:inquiry_a) { FactoryBot.build(:inquiry, name: 'メイラーSpec A') }
  # user_id無
  let(:inquiry_b) { FactoryBot.build(:inquiry, name: 'メイラーSpec B', user_id: nil) }

  let(:text_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/plain; charset=UTF-8' }
    part.body.raw_source
  end

  let(:html_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/html; charset=UTF-8' }
    part.body.raw_source
  end

  describe "メール作成（user_idあり）" do
    let(:mail) { InquiryMailer.with(name: inquiry_a.name, email: inquiry_a.email, contents: inquiry_a.contents, user_id: inquiry_a.user_id).creation_inquiry }

    it "想定どおりのメールが生成されている A" do
      # ヘッダ
      expect(mail.subject).to eq('【MyDailyLife】ユーザーからのお問い合わせ')

      # text形式の本文
      expect(text_body).to match('ユーザーからお問い合わせがありました。')
      expect(text_body).to match('メイラーSpec A')
      expect(text_body).to match('mailer@spec.com')
      expect(text_body).to match('▼ユーザーID')
      expect(text_body).to match('1')
      expect(text_body).to match('送信したメールの内容を確認するテスト')

      # html形式の本文
      expect(html_body).to match('ユーザーからお問い合わせがありました。')
      expect(html_body).to match('メイラーSpec A')
      expect(html_body).to match('mailer@spec.com')
      expect(html_body).to match('▼ユーザーID')
      expect(html_body).to match('1')
      expect(html_body).to match('送信したメールの内容を確認するテスト')
    end
  end

  describe "メール作成（user_idなし）" do
    let(:mail) { InquiryMailer.with(name: inquiry_b.name, email: inquiry_b.email, contents: inquiry_b.contents, user_id: inquiry_b.user_id).creation_inquiry }

    it "想定どおりのメールが生成されている B" do
      # ヘッダ
      expect(mail.subject).to eq('【MyDailyLife】ユーザーからのお問い合わせ')

      # text形式の本文
      expect(text_body).to match('ユーザーからお問い合わせがありました。')
      expect(text_body).to match('メイラーSpec B')
      expect(text_body).to match('mailer@spec.com')
      expect(text_body).not_to have_content '▼ユーザーID'
      expect(text_body).not_to have_content '1'
      expect(text_body).to match('送信したメールの内容を確認するテスト')

      # html形式の本文
      expect(html_body).to match('ユーザーからお問い合わせがありました。')
      expect(html_body).to match('メイラーSpec B')
      expect(html_body).to match('mailer@spec.com')
      expect(html_body).not_to have_content '▼ユーザーID'
      expect(html_body).not_to have_content '1'
      expect(html_body).to match('送信したメールの内容を確認するテスト')
    end
  end
end
