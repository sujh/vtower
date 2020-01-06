class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :title, null: false
      t.timestamps
      t.belongs_to :plan
    end
  end
end
