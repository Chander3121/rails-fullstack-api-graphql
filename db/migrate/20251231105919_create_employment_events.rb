class CreateEmploymentEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :employment_events do |t|
      t.references :employee_profile, null: false, foreign_key: true
      t.integer :event_type
      t.date :event_date
      t.text :notes

      t.timestamps
    end
  end
end
