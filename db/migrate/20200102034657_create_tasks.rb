class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, limit: 50
      t.string :content, null: false, limit: 2000
      t.integer :status, null: false, default: 0, limit: 1

      t.timestamps
      t.belongs_to :list
    end
  end
end
