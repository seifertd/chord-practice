class LoginSession < ApplicationRecord
  belongs_to :player
  before_create { self.token = SecureRandom.base58(24) }
end
