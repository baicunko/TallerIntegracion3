json.array!(@clients) do |client|
  json.extract! client, :id, :name, :address, :number, :phone, :rut
  json.url client_url(client, format: :json)
end
