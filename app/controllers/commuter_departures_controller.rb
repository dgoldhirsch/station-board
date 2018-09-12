class CommuterDeparturesController < ApplicationController
  def index
    @stop_id = stop_id_param

    # FIXME Would be better to validate the stop-id by trying to find it through the API
    head :not_found and return unless stop_id_param.in?(["place-north", "place-sstat"])

    @commuter_departures = CommuterDeparture.where(stop_id_param)

    render "error_getting_departures" and return if @commuter_departures.is_a?(String)
  end

  private

  def stop_id_param
    params[:stop_id]
  end
end
