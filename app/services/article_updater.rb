include ActionView::Helpers::SanitizeHelper

class ArticleUpdater
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def retrieve_and_update
    feed.entries.each do |article|
      puts "-> #{article.title}"
      puts "-> #{sanitize article.summary, tags: []}"
      puts "-> #{article.published}"
      puts "-> #{article.author}"
      puts "-> #{article.entry_id}"
      article_record = Article.where(guid: article.entry_id).order('id desc').last
      if article_record
        puts "--> Title changed!" if article_record.title != article.title
        puts "--> Summary changed!" if article_record.description != article.summary
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
