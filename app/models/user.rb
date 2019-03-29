class User < ApplicationRecord
  validates :user_id, length: { in: 6..20 }
  validates :password, length: { in: 8..20 }
end
