class User < ApplicationRecord
  attr_readonly :username
  ROLES = %w[admin manager employee hr].freeze
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: true

  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "is not a valid email address"
            }

  validates :username,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A@[a-z0-9]+(\.[a-z0-9]+)+\z/i,
              message: "must be in the format @firstname.lastname"
            }

  validates :password,
            length: { minimum: 8 },
            format: {
              with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/,
              message: "must include at least 1 uppercase letter, 1 lowercase letter, and 1 number"
            },
            if: :password_required?

  validates :role, inclusion: { in: ROLES }

  before_validation :generate_username, on: :create

  has_one_attached :resume
  has_one :employee_profile, dependent: :destroy

  after_create :create_employee_profile

  private

  def generate_username
    base = "@#{firstname.downcase}.#{lastname.downcase}"
    candidate = base
    counter = 1

    while User.exists?(username: candidate)
      candidate = "#{base}#{counter}"
      counter += 1
    end

    self.username = candidate
  end

  def create_employee_profile
    EmployeeProfile.create!(
      user: self,
      employee_id: "EMP#{id.to_s.rjust(4, '0')}",
      joining_date: Date.current,
      status: "active"
    )
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
