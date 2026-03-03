require "test_helper"

class SessionPracticeFlowTest < ActionDispatch::IntegrationTest
  setup do
    @player = Player.create!(
      name: "Practice Player",
      email_address: "practice@example.com",
      password: "password",
      chords: %w[A G D E C]
    )

    @session = @player.sessions.create!(duration: 1, complete: false)
    chords = Chord.all.select { |c| %w[A G D E C].include?(c.name) }
    @session.generate_random_pairs(3, chords: chords)
    @session.save!
    @pairs = @session.pairs.reload

    post login_path, params: { email_address: "practice@example.com", password: "password" }

    # GET the session page to pick up a CSRF token for subsequent JSON requests
    get session_path(@session)
    @csrf = response.body[/<meta name="csrf-token" content="([^"]+)"/, 1]
  end

  # --- helpers ---

  def patch_session(payload)
    patch session_path(@session),
          params: payload.to_json,
          headers: { "Content-Type" => "application/json", "X-CSRF-Token" => @csrf }
  end

  # --- response format ---

  test "returns 200 OK" do
    patch_session(pairs: [ { id: @pairs.first.id, switches: 10 } ])
    assert_response :ok
  end

  test "response body is empty" do
    patch_session(pairs: [ { id: @pairs.first.id, switches: 10 } ])
    assert_empty response.body
  end

  # --- switch count updates ---

  test "updates a single pair's switch count" do
    pair = @pairs.first
    patch_session(pairs: [ { id: pair.id, switches: 15 } ])
    assert_equal 15, pair.reload.switches
  end

  test "updates multiple pairs in a single request" do
    payload = { pairs: @pairs.first(2).map { |p| { id: p.id, switches: 8 } } }
    patch_session(payload)
    @pairs.first(2).each { |p| assert_equal 8, p.reload.switches }
  end

  test "only updates pairs included in the request" do
    untouched = @pairs.last
    patch_session(pairs: [ { id: @pairs.first.id, switches: 5 } ])
    assert_nil untouched.reload.switches
  end

  # --- auto-complete behaviour ---

  test "does not complete the session when pairs still have zero switches" do
    patch_session(pairs: [ { id: @pairs.first.id, switches: 10 } ])
    assert_not @session.reload.complete
  end

  test "auto-completes the session when all pairs receive switches" do
    payload = { pairs: @pairs.map { |p| { id: p.id, switches: 10 } } }
    patch_session(payload)
    assert @session.reload.complete
  end

  test "does not auto-complete if any pair still has zero switches after the update" do
    # Send switches for all but the last pair
    payload = { pairs: @pairs.first(@pairs.size - 1).map { |p| { id: p.id, switches: 10 } } }
    patch_session(payload)
    assert_not @session.reload.complete
  end
end
