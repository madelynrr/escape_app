class Hikes::TripsController < ApplicationController
  before_action :require_current_user

  def new
    @destination = Destination.new(session[:destination])

    lat = session[:destination]["lat"]
    lng = session[:destination]["lng"]
    all_hikes = EscapeService.new.get_hike_results(params, lat, lng)
    @hike_options = all_hikes.map do |hike_response|
      HikeOption.new(hike_response)
    end
    if @hike_options.count == 0
      flash[:notice] = "No results returned, please adjust your search and try again."
      redirect_to "/search/hikes/new"
    end
  end


  def create
    destination = session["destination"]
    new_trip = current_user.trips.create(
      name: "Trip #{current_user.trips.count + 1}: #{destination["name"]}",
      destination_name: destination["name"],
      destination_address: destination["address"],
      lat: destination["lat"],
      lng: destination["lng"]
    )

    hikes = params["hike_objects"]

    hikes.each do |hike|
      parsed_hike = JSON.parse(hike)
      new_trip.hikes.create!(
        name: parsed_hike["name"],
        rid: parsed_hike["rid"],
        url: parsed_hike["url"],
        lat: parsed_hike["lat"],
        lng: parsed_hike["lng"],
        summary: parsed_hike["summary"],
        difficulty: parsed_hike["difficulty"],
        stars: parsed_hike["stars"],
        location: parsed_hike["location"],
        length: parsed_hike["length"],
        ascent: parsed_hike["ascent"],
        high: parsed_hike["max_elevation"]
      )

    end
    redirect_to trip_path(new_trip)
  end
end
