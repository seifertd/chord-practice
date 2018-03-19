json.sessions do
  json.array! @sessions, partial: 'sessions/session', as: :session
end
json.player @current_player, :chords, :name
