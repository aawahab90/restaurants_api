json.id reservation.id
json.status reservation.status
json.start_time reservation.start_time
json.covers reservation.covers
json.note reservation.note
json.guest do
	json.partial! 'api/v1/guests/guest', guest: reservation.guest
end 