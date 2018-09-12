class Route
  include ActiveModel::Model

  ATTRIBUTES = [:color, :description, :long_name, :short_name, :sort_order, :text_order, :type].freeze

  attr_accessor :id

  ATTRIBUTES.each do |attribute_symbol|
    attr_accessor attribute_symbol
  end

  def self.inflate_from(hash, _other_objects = nil)
    symbolic_hash = hash.deep_symbolize_keys
    new(symbolic_hash[:attributes].slice(*ATTRIBUTES).merge(id: symbolic_hash[:id]))
  end

  def commuter?
    type == 2
  end
end
