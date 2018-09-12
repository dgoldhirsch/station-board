class Mbta
  def self.get_predictions(stop_id)
    url = "https://api-v3.mbta.com/predictions/?include=route,schedule,stop,trip&filter[stop]=#{stop_id}&filter[date]=#{Date.today.iso8601}&sort=departure-time"

    response = Faraday.get(url)

    if response.success?
      inflate_predictions_from(JSON.parse(response.body))
    else
      "Error getting predictions: #{response.status} body: #{JSON.parse(response.body)}"
    end
  end

  private

  def self.inflate_predictions_from(payload)
    included_hashes = payload["included"] || []

    routes = included_hashes.select { |hash| hash["type"] == "route" }.map { |hash| Route.inflate_from(hash) }
    stops = included_hashes.select { |hash| hash["type"] == "stop" }.map { |hash| Stop.inflate_from(hash) }
    trips = included_hashes.select { |hash| hash["type"] == "trip" }.map { |hash| Trip.inflate_from(hash) }

    payload["data"].map do |prediction_hash|
      Prediction.inflate_from(prediction_hash, { routes: routes, stops: stops, trips: trips })
    end
  end
end
