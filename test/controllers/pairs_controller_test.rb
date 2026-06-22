require "test_helper"

class PairsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:one)  # has chords A and B
    cookies[:player_id] = @player.uuid
    @session = @player.sessions.create!(duration: 1, complete: false)
    @pair = @session.pairs.create!(first: "A", second: "B")
  end

  test "destroy removes the pair from the session" do
    assert_difference "@session.pairs.count", -1 do
      delete pair_path(@pair)
    end
    assert_response :ok
  end

  test "destroy without block does not touch the blocklist" do
    delete pair_path(@pair)
    assert_empty @player.reload.blocked_pairs
  end

  test "destroy with block=true adds the pair to the blocklist" do
    delete pair_path(@pair), params: { block: "true" }
    assert_equal [ "A-B" ], @player.reload.blocked_pairs
  end

  test "destroy forbids removing another player's pair" do
    other = Player.create!(name: "Other", password: "password", uuid: "other-player")
    other_session = other.sessions.create!(duration: 1, complete: false)
    other_pair = other_session.pairs.create!(first: "A", second: "B")

    assert_no_difference "Pair.count" do
      delete pair_path(other_pair)
    end
    assert_response :forbidden
  end
end
