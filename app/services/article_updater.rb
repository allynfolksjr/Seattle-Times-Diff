include ActionView::Helpers::SanitizeHelper

class ArticleUpdater
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def retrieve_and_update
    article_guids = []
    feed.entries.each do |article|
      article_guids << article.entry_id
      persist_article(article)
    end
    FeedMailer.notify_on_refresh(article_guids, feed).deliver
  end

  private

  def persist_article(article)
    summary = sanitize(article.summary, tags: [])
    article_object = Article.new(
      title: article.title,
      description: summary,
      created_at: feed.last_built,
      updated_at: article.published,
      guid: article.entry_id
    )

    recent_article_history = Article.where(guid: article.entry_id).order('id desc').first
    # This has been seen before. Let's check if it was updated
    if recent_article_history.present?
      if recent_article_history.title != article.title
        article_object.updated = true
      end
      if recent_article_history.description != summary
        article_object.updated = true
      end
    # New article
    else
      article_object.first_appearance = true
    end

    article.object.save! if article_object.updated || article_object.first_appearance
  end

  def feed
    @feed ||= FeedRetriever.new.parse_feed(@feed_url)
  end
end
