json.array!(@sent_items_pedidos) do |sent_items_pedido|
  json.extract! sent_items_pedido, :id, :sku, :cantidad, :precio, :direccion, :pedidoid, :respuesta
  json.url sent_items_pedido_url(sent_items_pedido, format: :json)
end
