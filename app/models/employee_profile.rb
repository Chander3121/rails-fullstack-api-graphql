class EmployeeProfile < ApplicationRecord
  belongs_to :user
  has_many :salaries, dependent: :destroy
  has_many :leaves, dependent: :destroy
  has_many :employment_events, dependent: :destroy

  enum :employment_type, %w[full_time part_time contract intern]
  enum :status, %w[active resigned terminated]

  validates :employee_id, :joining_date, presence: true
end
