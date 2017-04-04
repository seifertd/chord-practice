json.(session, :id, :duration, :complete, :started, :done, :created_at)
json.pairs session.pairs, :id, :first_chord, :second_chord, :switches, :complete
