class SessionsController < ApplicationController
  def index
    @sessions = current_player.sessions
  end
end
