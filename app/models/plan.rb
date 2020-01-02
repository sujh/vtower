class Plan < ApplicationRecord

  validates_length_of :title, :description, within: 1..30

end