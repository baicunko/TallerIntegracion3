json.array!(@precios_temporals) do |precios_temporal|
  json.extract! precios_temporal, :id, :SKU, :precio
  json.url precios_temporal_url(precios_temporal, format: :json)
end
