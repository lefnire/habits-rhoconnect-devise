class CreateHabits < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.references :user
      t.string  :name
      t.text    :notes
      t.integer :position, :default => 0

      t.timestamps
    end
  end
end
