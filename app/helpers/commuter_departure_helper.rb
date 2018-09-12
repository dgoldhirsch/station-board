module CommuterDepartureHelper
  def displayable_time(time)
    time&.strftime("%l:%M %p")
  end

  def station_name(stop_id)
    # FIXME Would be better to fetch the name from the actual Stop resource
    case stop_id
    when "place-north"
      "North Station"
    when "place-sstat"
      "South Station"
    else
      stop_id
    end
  end
end
