class NotifierMailerPreview < ActionMailer::Preview

  def email_friend(Article.first, 'Erica', 'brianna@zepho.com')
    NotifierMailer.email_friend(Article.first, 'Erica', 'brianna@zepho.com')
  end
end
