class Country < ApplicationRecord
  include MeiliSearch::Rails
  meilisearch do
    attributes :name, :first_year, :last_year, :army, :area, :population
  end
end