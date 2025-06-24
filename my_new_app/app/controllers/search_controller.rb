class SearchController < ApplicationController
def search
  query = params[:q]

  @users = User.search(query)
  @notes = Note.search(query)

  # Если хочешь, можно объединить результаты, но лучше показывать отдельно
end
end
