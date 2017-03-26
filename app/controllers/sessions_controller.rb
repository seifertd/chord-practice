class SessionsController < ApplicationController
  before_action :get_session, only: [:show, :destroy]
  def index
    @sessions = current_player.sessions
  end

  def show
  end

  def destroy
    @session.destroy
  end

  # POST /sessions
  def create
    request.format = :json
    @session = current_player.sessions.create!(session_params.merge(complete: false))
    @session.generate_random_pairs(params[:session][:numberOfSwitches])
    @session.save!
  end

  private

  def session_params
    params.require(:session).permit(:duration, :complete)
  end

  def get_session
    @session = Session.find(params[:id])
  end
end
