require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # generate_random_pairs (existing tests)

  test "can create with random pairs" do
    session = Session.new
    session.generate_random_pairs(5)
    assert session.pairs.size == 5
  end

  test "creates uniq pairs" do
    session = Session.new(player: players(:one))
    session.generate_random_pairs(8)
    session.save!
    assert session.pairs.map{|pair| [pair.first, pair.second].join('-')}.uniq.size == 8
  end

  # generate_random_pairs (new)

  test "generate_random_pairs uses a provided chord list" do
    chords = Chord.all.select { |c| %w[A G D].include?(c.name) }
    session = Session.new(player: players(:one))
    session.generate_random_pairs(3, chords: chords)
    used_names = session.pairs.flat_map { |p| [p.first, p.second] }.uniq
    assert_empty used_names - %w[A G D]
  end

  test "generate_random_pairs with :random switches sets switches between 5 and 104" do
    session = Session.new(player: players(:one))
    session.generate_random_pairs(10, switches: :random)
    session.pairs.each do |pair|
      assert_includes 5..104, pair.switches
    end
  end

  test "generate_random_pairs caps at the number of available chord combinations" do
    # Two chords → only one possible pair (A-G)
    chords = Chord.all.select { |c| %w[A G].include?(c.name) }
    session = Session.new(player: players(:one))
    session.generate_random_pairs(10, chords: chords)
    assert_equal 1, session.pairs.size
  end

  # started

  test "started is false when the session has no pairs" do
    session = Session.new(player: players(:one))
    assert_not session.started
  end

  test "started is false when all pairs have zero switches" do
    session = Session.new(player: players(:one))
    session.pairs.build(first: 'A', second: 'G', switches: 0)
    session.pairs.build(first: 'A', second: 'D', switches: 0)
    assert_not session.started
  end

  test "started is true when at least one pair has switches recorded" do
    session = Session.new(player: players(:one))
    session.pairs.build(first: 'A', second: 'G', switches: 0)
    session.pairs.build(first: 'A', second: 'D', switches: 12)
    assert session.started
  end

  # done

  test "done is false when some pairs have zero switches" do
    session = Session.new(player: players(:one))
    session.pairs.build(first: 'A', second: 'G', switches: 10)
    session.pairs.build(first: 'A', second: 'D', switches: 0)
    assert_not session.done
  end

  test "done is true when every pair has switches recorded" do
    session = Session.new(player: players(:one))
    session.pairs.build(first: 'A', second: 'G', switches: 10)
    session.pairs.build(first: 'A', second: 'D', switches: 5)
    assert session.done
  end
end
