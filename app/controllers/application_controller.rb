class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def current_player
    player_id = cookies[:player_id] || session.id
    @current_player ||= Player.find_or_create_by(uuid: player_id)
  end
end
