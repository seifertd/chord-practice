module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :resume_session
    helper_method :current_player, :authenticated?
  end

  private

  def resume_session
    if (token = cookies.signed[:session_token])
      login_session = LoginSession.find_by(token: token)
      if login_session
        Current.session = login_session
        Current.player = login_session.player
        return
      end
    end

    # Fall back to anonymous session-based player (find or create)
    player_uuid = cookies[:player_id] || session.id&.public_id
    Current.player = Player.find_or_create_by(uuid: player_uuid)
  end

  def start_new_session_for(player)
    login_session = player.login_sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    )
    Current.session = login_session
    Current.player = player
    cookies.signed.permanent[:session_token] = {
      value: login_session.token,
      httponly: true,
      same_site: :lax
    }
  end

  def terminate_session
    Current.session&.destroy
    Current.session = nil
    cookies.delete(:session_token)
  end

  def current_player
    Current.player
  end

  def authenticated?
    Current.session.present?
  end
end
