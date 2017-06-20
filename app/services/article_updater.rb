include ActionView::Helpers::SanitizeHelper

class ArticleUpdater
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def retrieve_and_update
    feed.entries.each do |article|
      article_record = Article.where(guid: article.entry_id).order('id desc').first
      summary =  sanitize(article.summary, tags: [])
      if article_record
        if article_record.title != article.title
          puts "--> Title changed‘’!"
          puts "--> Old title: #{article_record.title}. New title: #{article.title}"
        end
        if article_record.description != summary
          puts "--> Summary changed!"
          puts "--> Old summary: #{article_record.description}. New title: #{summary}"
        end
      end
      persist_article(article)
    end
    nil
  end

  private

  def persist_article(article)
    Article.create!(
      title: article.title,
      description: sanitize(article.summary, tags: []),
      created_at: article.published,
      guid: article.entry_id
    )
  end

  def feed
    @feed ||= FeedRetriever.new.parse_feed(@feed_url)
  end
end
