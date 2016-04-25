json.array!(@navigations) do |navigation|
  json.extract! navigation, :id
  json.url navigation_url(navigation, format: :json)
end
