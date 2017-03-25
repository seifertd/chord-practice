class Pair < ApplicationRecord
  belongs_to :session
  def complete
    switches?
  end
end
