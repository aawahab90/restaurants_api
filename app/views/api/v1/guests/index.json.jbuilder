json.key_format! camelize: :lower

json.status do
  json.code 0
  json.message 'OK'
end

json.data do
  json.guests @guests do |guest|
    json.partial! 'guest', guest: guest
  end

  json.pagination do
    json.current_page @guests.current_page
    json.total_pages @guests.total_pages
    json.total_count @guests.total_entries
  end
end
