class Salary < ApplicationRecord
  belongs_to :employee_profile

  validates :base_salary, :effective_from, presence: true
  validates :base_salary, numericality: { greater_than: 0 }
  validates :bonus, :deductions, numericality: true, allow_nil: true
end
