class CreateLeaves < ActiveRecord::Migration[8.1]
  def change
    create_table :leaves do |t|
      t.references :employee_profile, null: false, foreign_key: true
      t.integer :leave_type
      t.date :start_date
      t.date :end_date
      t.integer :status
      t.text :reason

      t.timestamps
    end
  end
end
