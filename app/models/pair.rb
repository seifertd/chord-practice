class Pair < ApplicationRecord
  belongs_to :session
  def complete
    switches?
  end
  def first_chord
    Chord.all.find {|chord| chord.name == first}
  end
  def second_chord
    Chord.all.find {|chord| chord.name == second}
  end
end
