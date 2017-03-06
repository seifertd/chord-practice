require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "Players know chords" do
    assert_equal ['A', 'B'], players(:one).chords
  end
  test "Players can learn new chords" do
    players(:one).chords_will_change!
    players(:one).chords << "G"
    players(:one).save
    assert_equal ['A', 'B', 'G'], players(:one).reload.chords
  end
  test "Players can forget chords" do
    players(:one).chords_will_change!
    players(:one).chords.delete 'A'
    players(:one).save
    assert_equal ['B'], players(:one).reload.chords
  end
end
