class SearchController < ApplicationController
  def new
    @activities = ["climbing", "hiking"]
  end

  def create

    destination = params[:destination].delete(' ')
    response = Faraday.get("https://escape-app-api.herokuapp.com/api/v1/destination/#{destination}")

    parsed_json = JSON.parse(response.body)
    # location = GooglePlaceService.new(params['destination'])

    if params[:selected_activity].first == "climbing"

      redirect_to '/search/climb'
    end
  end
end
