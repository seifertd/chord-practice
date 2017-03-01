class ChordsController < ApplicationController
  def index
    @chord = {
      name: "E",
      notes: [[5,2], [4,2], [3,1]],
      bases: ["6", "4/5"]
    }
  end
end
