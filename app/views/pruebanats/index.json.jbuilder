json.array!(@pruebanats) do |pruebanat|
  json.extract! pruebanat, :id
  json.url pruebanat_url(pruebanat, format: :json)
end
