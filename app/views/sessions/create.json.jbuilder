json.session do
  json.(@session, :id, :duration, :complete, :created_at)
  json.pairs @session.pairs, :id, :first, :second, :switches
end
