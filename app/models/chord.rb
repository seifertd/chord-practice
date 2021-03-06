Chord = Struct.new(:name, :notes, :bases) do
  def self.all
    [
      Chord.new('A', [-1, 0, 2, 2, 2, 0], ["5", "6"]),
      Chord.new('A7', [-1, 0, 2, 0, 2, 0], ["5", "6"]),
      Chord.new('Am', [-1, 0, 2, 2, 1, 0], ["5", "6"]),
      Chord.new('Am7', [-1, 0, 2, 0, 1, 0], ["5", "6"]),
      Chord.new('Asus4', [-1, 0, 2, 2, 3, 0], ["5", "6"]),
      Chord.new('Asus2', [-1, 0, 2, 2, 0, 0], ["5", "6"]),
      Chord.new('A5', [-1, 0, 2, 2, 0, 0], ["5", "6"]),
      Chord.new('B', [-1, -1, 4, 4, 4, 2], []),
      Chord.new('B7', [-1, 2, 1, 2, 0, 2], []),
      Chord.new('C', [3, 3, 2, 0, 1, 0], ["5", "6"]),
      Chord.new('C7', [-1, 3, 2, 3, 1, 0], ["5", "4"]),
      Chord.new('D', [-1, -1, 0, 2, 3, 2], ["4", "5"]),
      Chord.new('Dm', [-1, -1, 0, 2, 3, 1], ["4", "5"]),
      Chord.new('D7', [-1, -1, 0, 2, 1, 2], ["4", "5"]),
      Chord.new('E', [0, 2, 2, 1, 0, 0], ["6", "4/5"]),
      Chord.new('Em', [0, 2, 2, 0, 0, 0], ["6", "4/5"]),
      Chord.new('F', [-1, 3, 3, 2, 1, 1, "B-1-21"], ["4", "5"]),
      Chord.new('Fbar', [1, 3, 3, 2, 1, 1, "B-1-61"], ["6", "4/5"]),
      Chord.new('G', [3, 2, 0, 0, 0, 3], ["6", "4"]),
      Chord.new('G7', [3, 2, 3, 0, 0, 1], ["6", "4"])
    ]
  end
end
