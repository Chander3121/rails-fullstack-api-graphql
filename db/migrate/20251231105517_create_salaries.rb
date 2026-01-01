class CreateSalaries < ActiveRecord::Migration[8.1]
  def change
    create_table :salaries do |t|
      t.references :employee_profile, null: false, foreign_key: true
      t.decimal :base_salary
      t.decimal :bonus
      t.decimal :deductions
      t.date :effective_from

      t.timestamps
    end
  end
end
