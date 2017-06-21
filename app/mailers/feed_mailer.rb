class FeedMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.feed_mailer.notify_on_refresh.subject
  #
  def notify_on_refresh(article_guids, feed)
    @article_guids = article_guids
    @feed = feed

    mail to: ENV['NOTIFY_EMAIL']
  end
end
