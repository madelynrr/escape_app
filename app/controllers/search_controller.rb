class SearchController < ApplicationController
  def new
    available_activities
  end

  def create
    destination = params[:destination].delete(' ')
    destination_info = EscapeService.new.get_destination_info(destination)
    if destination_info == 404 || destination_info.nil?
      destination_error
    elsif params[:selected_activity].nil?
      activity_selector_error
    else
      save_destination_to_session(destination_info)
      redirect_to_activity_search
    end
  end

  private

  def save_destination_to_session(destination_info)
    name = destination_info[:name]
    address = destination_info[:formatted_address]
    lat = destination_info[:geometry][:location][:lat]
    lng = destination_info[:geometry][:location][:lng]
    session[:destination] = { name: name, address: address, lat: lat, lng: lng}
  end

  def redirect_to_activity_search
    if params[:selected_activity].first == "climbing"
      redirect_to '/search/climbs/new'
    end
  end

  def destination_error
    flash[:notice] = "The destination you entered cannot be found. Please try again."
    available_activities
    render :new
  end

  def activity_selector_error
    flash[:notice] = "Please select one activity."
    available_activities
    render :new
  end
end