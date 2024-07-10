class SearchService

  MODELS_THAT_SUPPORT_SEARCH = ["Question", "Answer", "Comment", "User" ]
  SEARCH_IN_ALL_MODELS = "Global"

  def self.call(search_params)
    if MODELS_THAT_SUPPORT_SEARCH.include? search_params[:area]
      search_result = Object.const_get(search_params[:area]).search "#{search_params[:query]}"   
    elsif search_params[:area] == SEARCH_IN_ALL_MODELS
      search_result = ThinkingSphinx.search "#{search_params[:query]}"
    else
      search_result = []
    end
  end
end
