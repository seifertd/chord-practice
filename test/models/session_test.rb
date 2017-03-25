require 'test_helper'

class SessionTest < ActiveSupport::TestCase
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
end
