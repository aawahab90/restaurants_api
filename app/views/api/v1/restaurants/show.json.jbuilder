json.key_format! camelize: :lower

json.status do
  json.code 0
  json.message 'OK'
end

json.data do
  json.partial! 'restaurant', restaurant: @restaurant
end