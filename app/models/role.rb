class Role < ApplicationRecord
  validates_presence_of :name, :code
  validates_uniqueness_of :name, :code

  has_many :role_ships
  has_many :users, through: :role_ships
end
