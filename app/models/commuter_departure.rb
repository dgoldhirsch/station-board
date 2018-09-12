class CommuterDeparture
  include ActiveModel::Model
  attr_accessor :departure_time
  attr_accessor :destination
  attr_accessor :status
  attr_accessor :track_number

  def self.where(station_name)
    predictions = ::Mbta.get_predictions(station_name)

    return predictions if predictions.is_a?(String) # API error

    predicted_commuter_rail_departures = predictions.select do |prediction|
      prediction.route.commuter? && prediction.departure_time.present?
    end

    predicted_commuter_rail_departures.map do |predicted_departure|
      new(
        departure_time: predicted_departure.departure_time,
        destination: predicted_departure.trip.headsign,
        status: predicted_departure.status,
        track_number: predicted_departure.meaningful_platform_code
      )
    end
  end
end
