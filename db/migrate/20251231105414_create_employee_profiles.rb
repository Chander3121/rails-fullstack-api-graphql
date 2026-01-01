class CreateEmployeeProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :employee_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :employee_id
      t.string :designation
      t.string :department
      t.date :joining_date
      t.date :exit_date
      t.integer :employment_type
      t.integer :status

      t.timestamps
    end
  end
end
