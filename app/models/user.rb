class User < ApplicationRecord
  has_many :products, dependent: :nullify
end
