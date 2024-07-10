class SearchController < ApplicationController
  skip_authorization_check

  def search
    @search_result = SearchService.call(search_params)   
  end

  private

  def search_params
    params.permit(:query, :area, :commit)
  end
end
