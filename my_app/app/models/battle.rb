class Battle < ApplicationRecord
  include MeiliSearch::Rails
  meilisearch do
    attributes :name, :number, :first_belligerents, :second_belligerents, :date, :who_win, :army_of_first_belligerents, :army_of_second_belligerents
  end
end