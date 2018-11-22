json.key_format! camelize: :lower

json.status do
  json.code 0
  json.message 'OK'
end

json.data do
  json.restaurants @restaurants do |restaurant|
    json.partial! 'restaurant', restaurant: restaurant
  end

  json.pagination do
    json.current_page @restaurants.current_page
    json.total_pages @restaurants.total_pages
    json.total_count @restaurants.total_entries
  end
end
