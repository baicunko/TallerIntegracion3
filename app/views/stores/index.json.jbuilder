json.array!(@stores) do |store|
  json.extract! store, :id, :id, :used_space, :total_space, :reception, :dispatch, :lung
  json.url store_url(store, format: :json)
end
