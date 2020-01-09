class List < ApplicationRecord

  validates_length_of :title, in: 1..20
  has_many :tasks, dependent: :destroy

end
