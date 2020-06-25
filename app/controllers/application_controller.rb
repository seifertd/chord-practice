class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_player
  def current_player
    player_id = cookies[:player_id] || session.id&.public_id
    @current_player ||= Player.find_or_create_by(uuid: player_id)
  end
end
