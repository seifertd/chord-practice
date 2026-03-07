class SessionsController < ApplicationController
  before_action :get_session, only: [ :show, :destroy, :update ]
  def index
    @sessions = current_player.sessions.includes(:pairs).order(created_at: :desc)
    @available_pairs = current_player.chords.sort.combination(2).map { |a, b| "#{a}-#{b}" }
  end

  def show
    unless @session.complete
      chord_lookup = Chord.all.index_by(&:name)
      @pairs_with_chords = @session.pairs.map do |pair|
        [ pair, chord_lookup[pair.first], chord_lookup[pair.second] ]
      end
      @start_pair_idx = @session.pairs.index { |p| !p.complete } || 0
    end
  end

  def destroy
    @session.destroy
    redirect_to sessions_path
  end

  # POST /sessions
  def create
    @session = current_player.sessions.create!(session_params.merge(complete: false))
    selected_pairs = params[:session][:selected_pairs].presence
    if selected_pairs
      selected_pairs.each do |pair_name|
        first, second = pair_name.split("-", 2)
        @session.pairs.create!(first: first, second: second)
      end
    else
      @session.generate_random_pairs(
        params[:session][:number_of_pairs].to_i,
        chords: current_player.chords.map { |name| Chord.all.find { |chord| chord.name == name } }
      )
      @session.save!
    end
    redirect_to sessions_path
  end

  # PUT /sessions/:id
  def update
    request.format = :json
    logger.debug("Session #{@session.id} is complete? #{params['complete']}")
    @session.complete = params["complete"]
    params["pairs"].each_with_index do |new_pair, idx|
      old_pair = @session.pairs.find { |c| c.id == new_pair["id"] }
      old_pair.switches = new_pair["switches"]
      logger.debug("   -> Pair #{idx} number of switches: #{new_pair['switches']}")
      old_pair.save
    end
    @session.complete = @session.done
    @session.save
    head :ok
  end

  private

  def session_params
    params.require(:session).permit(:duration, :complete)
  end

  def get_session
    @session = Session.find(params[:id])
  end
end
