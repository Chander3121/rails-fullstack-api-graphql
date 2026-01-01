class EmploymentEvent < ApplicationRecord
  belongs_to :employee_profile

  enum :event_type, %w[onboarding offboarding promotion role_change]
end
