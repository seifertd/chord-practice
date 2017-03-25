json.sessions do
  json.array! @sessions, partial: 'sessions/session', as: :session
end
