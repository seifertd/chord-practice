class SessionsController < ApplicationController
  before_action :get_session, only: [:show]
  def index
    @sessions = current_player.sessions
  end

  def show
  end

  # POST /sessions
  def create
    @session = current_player.sessions.create!(session_params.merge(complete: false))
    @session.generate_random_pairs(params[:numberOfSwitches])
  end

  private

  def session_params
    params.permit(:duration, :complete)
  end

  def get_session
    @session = Session.find(params[:id])
  end
end
