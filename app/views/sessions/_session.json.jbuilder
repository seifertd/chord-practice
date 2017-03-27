json.(session, :id, :duration, :complete, :created_at)
json.pairs session.pairs, :id, :first_chord, :second_chord, :switches, :complete
