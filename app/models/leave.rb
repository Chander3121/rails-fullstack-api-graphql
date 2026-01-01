class Leave < ApplicationRecord
  belongs_to :employee_profile
  has_one :user, through: :employee_profile

  enum :leave_type, %w[casual sick earned unpaid]
  enum :status, %w[pending approved rejected]

  validates :start_date, :end_date, :leave_type, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "must be greater than start date")
    end
  end
end
