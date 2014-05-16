json.array!(@reservas) do |reserva|
  json.extract! reserva, :id, :fecha, :cliente, :sku, :cantidad, :responsable
  json.url reserva_url(reserva, format: :json)
end
