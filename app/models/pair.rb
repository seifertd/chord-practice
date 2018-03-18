class Pair < ApplicationRecord
  belongs_to :session
  def complete
    switches && switches > 0
  end
  def first_chord
    @fc ||= Chord.all.find {|chord| chord.name == first}
  end
  def second_chord
    @sc ||= Chord.all.find {|chord| chord.name == second}
  end
end
