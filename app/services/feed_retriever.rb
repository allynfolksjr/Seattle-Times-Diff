class FeedRetriever
  def parse_feed(feed_url)
    Feedjira::Feed.fetch_and_parse(feed_url)
  end
end
