class Stop
  include ActiveModel::Model

  ATTRIBUTES = [:platform_name, :platform_code, :name].freeze

  attr_accessor :id

  ATTRIBUTES.each do |attribute_symbol|
    attr_accessor attribute_symbol
  end

  def self.inflate_from(hash, _other_objects = nil)
    symbolic_hash = hash.deep_symbolize_keys
    new(symbolic_hash[:attributes].slice(*ATTRIBUTES).merge(id: symbolic_hash[:id]))
  end
end
