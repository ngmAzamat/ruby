class Note < ApplicationRecord
  include MeiliSearch::Rails

  meilisearch do
    attribute :title, :content
  end
end