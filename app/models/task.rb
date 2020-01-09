class Task < ApplicationRecord

  validates_length_of :title, in: 1..50
  validates_length_of :content, in: 1..2000

  enum status: [:opened, :closed]

end
