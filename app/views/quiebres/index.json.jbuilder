json.array!(@quiebres) do |quiebre|
  json.extract! quiebre, :id, :pedido, :nombrecliente, :fechaquiebre
  json.url quiebre_url(quiebre, format: :json)
end
