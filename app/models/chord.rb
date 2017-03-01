Chord = Struct.new(:name, :notes, :bases) do
  def self.all
    [
      Chord.new('E', [[5,2], [4,2], [3,1]], ["6", "4/5"]),
      Chord.new('A', [[4,2], [3,2], [2,2]], ["5", "6"])
    ]
  end
end
