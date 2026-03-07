require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:one)  # has chords A and B
    cookies[:player_id] = @player.uuid
  end

  # Random mode

  test "create in random mode generates the requested number of pairs" do
    assert_difference "@player.sessions.count" do
      post sessions_path, params: { session: { duration: 1, number_of_pairs: 1 } }
    end
    assert_redirected_to sessions_path
    assert_equal 1, @player.sessions.last.pairs.count
  end

  test "create in random mode sets the duration" do
    post sessions_path, params: { session: { duration: 2, number_of_pairs: 1 } }
    assert_equal 2, @player.sessions.last.duration
  end

  # Custom mode

  test "create in custom mode builds exactly the specified pairs" do
    assert_difference "@player.sessions.count" do
      post sessions_path, params: { session: { duration: 1, selected_pairs: [ "A-B" ] } }
    end
    assert_redirected_to sessions_path
    session = @player.sessions.last
    assert_equal 1, session.pairs.count
    assert_equal "A", session.pairs.first.first
    assert_equal "B", session.pairs.first.second
  end

  test "create in custom mode with multiple pairs builds all of them" do
    player = Player.create!(name: "Multi", password: "password", uuid: "multi-player")
    cookies[:player_id] = player.uuid

    post sessions_path, params: { session: { duration: 1, selected_pairs: [ "A-B", "A-C", "B-C" ] } }
    session = player.sessions.last
    assert_equal 3, session.pairs.count
    pair_names = session.pairs.map { |p| "#{p.first}-#{p.second}" }
    assert_includes pair_names, "A-B"
    assert_includes pair_names, "A-C"
    assert_includes pair_names, "B-C"
  end

  test "create in custom mode sets the duration" do
    post sessions_path, params: { session: { duration: 3, selected_pairs: [ "A-B" ] } }
    assert_equal 3, @player.sessions.last.duration
  end
end
