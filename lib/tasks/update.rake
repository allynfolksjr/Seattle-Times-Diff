namespace :update do
  desc "Retrieves latest RSS Feed and persists it"
  task run: :environment do
    ArticleUpdater.new('http://www.seattletimes.com/seattle-news/feed/').retrieve_and_update
  end

end
