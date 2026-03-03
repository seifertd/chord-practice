require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # chords (existing tests)

  test "Players know chords" do
    assert_equal ['A', 'B'], players(:one).chords
  end

  test "Players can learn new chords" do
    players(:one).update(chords: players(:one).chords + ["G"])
    assert_equal ['A', 'B', 'G'], players(:one).reload.chords
  end

  test "Players can forget chords" do
    players(:one).update(chords: players(:one).chords - ['A'])
    assert_equal ['B'], players(:one).reload.chords
  end

  # email normalization

  test "email address is stripped and lowercased on save" do
    player = Player.create!(name: 'Test', email_address: '  TEST@Example.COM  ', password: 'password')
    assert_equal 'test@example.com', player.reload.email_address
  end

  # chord_pair_data

  test "chord_pair_data returns a data point per complete session" do
    player = Player.create!(name: 'Test', password: 'password')
    s = player.sessions.create!(duration: 2, complete: true)
    s.pairs.create!(first: 'A', second: 'G', switches: 20)

    data = player.chord_pair_data
    assert_equal 1, data['A-G'].size
    assert_equal 10.0, data['A-G'].first[:y]   # 20 switches / 2 min
  end

  test "chord_pair_data y value is rounded to one decimal place" do
    player = Player.create!(name: 'Test', password: 'password')
    s = player.sessions.create!(duration: 3, complete: true)
    s.pairs.create!(first: 'A', second: 'G', switches: 10)

    data = player.chord_pair_data
    assert_equal 3.3, data['A-G'].first[:y]    # 10 / 3 = 3.333... → 3.3
  end

  test "chord_pair_data stops processing when it encounters an incomplete session" do
    player = Player.create!(name: 'Test', password: 'password')
    # Incomplete session has a lower id so it comes first in default order
    s1 = player.sessions.create!(duration: 1, complete: false)
    s1.pairs.create!(first: 'A', second: 'G', switches: 10)
    s2 = player.sessions.create!(duration: 1, complete: true)
    s2.pairs.create!(first: 'D', second: 'G', switches: 15)

    data = player.chord_pair_data
    assert_not data.key?('D-G'), "should not include sessions after the incomplete one"
  end

  test "chord_pair_data x value is an ISO8601 timestamp" do
    player = Player.create!(name: 'Test', password: 'password')
    s = player.sessions.create!(duration: 1, complete: true)
    s.pairs.create!(first: 'A', second: 'G', switches: 5)

    x = player.chord_pair_data['A-G'].first[:x]
    assert_match /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, x
  end

  # chord_pairs

  test "chord_pairs counts how many sessions each pair appeared in" do
    player = Player.create!(name: 'Test', password: 'password')
    3.times do
      s = player.sessions.create!(duration: 1, complete: true)
      s.pairs.create!(first: 'A', second: 'G', switches: 5)
    end

    assert_equal 3, player.chord_pairs['A-G']
  end

  test "chord_pairs returns zero for a pair that has not been practiced" do
    player = Player.create!(name: 'Test', password: 'password')
    assert_equal 0, player.chord_pairs['A-G']
  end

  test "chord_pairs counts different pairs independently" do
    player = Player.create!(name: 'Test', password: 'password')
    s1 = player.sessions.create!(duration: 1, complete: true)
    s1.pairs.create!(first: 'A', second: 'G', switches: 5)
    s1.pairs.create!(first: 'D', second: 'G', switches: 3)
    s2 = player.sessions.create!(duration: 1, complete: true)
    s2.pairs.create!(first: 'A', second: 'G', switches: 8)

    assert_equal 2, player.chord_pairs['A-G']
    assert_equal 1, player.chord_pairs['D-G']
  end
end
