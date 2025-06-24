MeiliSearch::Rails.configuration = {
  meilisearch_host: ENV.fetch('MEILISEARCH_URL', 'http://meilisearch:7700'),
  meilisearch_api_key: ENV.fetch('MEILISEARCH_API_KEY', '')
}
