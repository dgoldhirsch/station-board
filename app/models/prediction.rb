class Prediction
  include ActiveModel::Model

  ATTRIBUTES = [:arrival_time, :departure_time, :status, :route_id, :route, :stop_id, :stop, :trip_id, :trip].freeze
  ALL_ABOARD = "All aboard".freeze
  BOARDING = "Now boarding".freeze

  attr_accessor :id

  ATTRIBUTES.each do |attribute_symbol|
    attr_accessor attribute_symbol
  end

  def all_aboard?
    status == ALL_ABOARD
  end

  def boarding?
    status == BOARDING
  end

  def meaningful_platform_code
    if status.present?
      if all_aboard? || boarding?
        stop.platform_code
      else
        "TBD"
      end
    end
  end

  def self.inflate_from(hash, other_objects)
    symbolic_hash = hash.deep_symbolize_keys
    raw_attrs = OpenStruct.new(symbolic_hash[:attributes].slice(*ATTRIBUTES).merge(id: symbolic_hash[:id]))

    Prediction.new(
      id: raw_attrs.id,
      arrival_time: raw_attrs.arrival_time ? Time.parse(raw_attrs.arrival_time) : nil,
      departure_time: raw_attrs.departure_time ? Time.parse(raw_attrs.departure_time) : nil,
      status: raw_attrs.status,
      route: other_objects[:routes].detect { |r| r.id == symbolic_hash.dig(:relationships, :route, :data, :id) },
      stop: other_objects[:stops].detect { |s| s.id == symbolic_hash.dig(:relationships, :stop, :data, :id) },
      trip: other_objects[:trips].detect { |t| t.id == symbolic_hash.dig(:relationships, :trip, :data, :id) }
    )
  end
end
