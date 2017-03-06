json.key_format! camelize: :lower
json.set! :chords do
  json.array! @chords
end
json.set! :player, @player
