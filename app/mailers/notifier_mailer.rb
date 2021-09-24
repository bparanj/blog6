class NotifierMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier_mailer.email_friend.subject
  #
  def email_friend(article, sender_name, receiver_email)
    @article = article 
    @sender_name = sender_name

    mail to: receiver_email, subject: 'Great article'
  end
end
