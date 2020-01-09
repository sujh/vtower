class List < ApplicationRecord

  validates_length_of :title, in: 1..20
  validates_length_of :tasks, maximum: 100, on: :create
  has_many :tasks, dependent: :destroy

end
