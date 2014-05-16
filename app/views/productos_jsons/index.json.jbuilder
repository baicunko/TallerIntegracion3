json.array!(@productos_jsons) do |productos_json|
  json.extract! productos_json, :id, :SKU, :Marca, :Modelo, :PrecioNormal, :PrecioInternet, :Descripcion, :Imagen, :Categoria1, :Categoria2, :Categoria3, :Categoria4, :Categoria5, :Categoria6, :Categoria7, :Categoria8
  json.url productos_json_url(productos_json, format: :json)
end
