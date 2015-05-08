json.array!(@posts) do |post|
  json.extract! post, :id, :heading, :body, :price, :state, :external_url, :timestamp
  json.url post_url(post, format: :json)
end
