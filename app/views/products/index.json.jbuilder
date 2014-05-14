json.array!(@products) do |product|
  json.extract! product, :id, :sku, :store_id, :costs
  json.url product_url(product, format: :json)
end
