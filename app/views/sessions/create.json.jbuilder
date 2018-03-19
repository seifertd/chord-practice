json.session do
  json.partial! 'sessions/session', session: @session
end
json.player @current_player, :chords, :name
