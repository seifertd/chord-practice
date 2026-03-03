require 'test_helper'

class PairTest < ActiveSupport::TestCase
  setup do
    @session = sessions(:one)
  end

  # complete

  test "complete is false when switches is zero" do
    pair = Pair.new(session: @session, first: 'A', second: 'G', switches: 0)
    assert_not pair.complete
  end

  test "complete is false when switches is nil" do
    pair = Pair.new(session: @session, first: 'A', second: 'G')
    assert_not pair.complete
  end

  test "complete is true when switches is greater than zero" do
    pair = Pair.new(session: @session, first: 'A', second: 'G', switches: 1)
    assert pair.complete
  end

  # first_chord / second_chord

  test "first_chord returns the matching chord struct" do
    pair = Pair.new(first: 'G', second: 'D')
    assert_equal 'G', pair.first_chord.name
  end

  test "second_chord returns the matching chord struct" do
    pair = Pair.new(first: 'G', second: 'D')
    assert_equal 'D', pair.second_chord.name
  end

  test "first_chord returns nil for an unknown chord name" do
    pair = Pair.new(first: 'Z')
    assert_nil pair.first_chord
  end

  test "second_chord returns nil for an unknown chord name" do
    pair = Pair.new(second: 'Z')
    assert_nil pair.second_chord
  end
end
