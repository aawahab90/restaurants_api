json.key_format! camelize: :lower

json.status do
  json.code 0
  json.message 'OK'
end

json.data do
  json.reservations @reservations do |reservation|
    json.partial! 'reservation', reservation: reservation
  end

  json.pagination do
    json.current_page @reservations.current_page
    json.total_pages @reservations.total_pages
    json.total_count @reservations.total_entries
  end
end
