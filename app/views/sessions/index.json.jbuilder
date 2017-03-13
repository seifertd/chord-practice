json.key_format! camelize: :lower
json.set! :sessions do
  json.array! @sessions
end
