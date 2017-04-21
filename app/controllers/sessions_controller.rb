class SessionsController < ApplicationController
  before_action :get_session, only: [:show, :destroy, :update]
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

  # PUT /sessions/:id
  def update
    request.format = :json
    logger.debug("Session #{@session.id} is complete? #{params['complete']}")
    @session.complete = params['complete']
    params['pairs'].each_with_index do |new_pair, idx|
      old_pair = @session.pairs.find {|c| c.id == new_pair['id'] }
      old_pair.switches = new_pair['switches']
      logger.debug("   -> Pair #{idx} number of switches: #{new_pair['switches']}")
      old_pair.save
    end
    @session.save
  end

  private

  def session_params
    params.require(:session).permit(:duration, :complete)
  end

  def get_session
    @session = Session.find(params[:id])
  end
end
