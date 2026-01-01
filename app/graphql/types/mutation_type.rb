# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    field :login, mutation: Mutations::Login
    field :create_employee, mutation: Mutations::CreateEmployee
    field :logout, mutation: Mutations::Logout
    field :update_employee, mutation: Mutations::UpdateEmployee
    field :apply_leave, mutation: Mutations::ApplyLeave
    field :create_employee_salary, mutation: Mutations::CreateSalary

    def test_field
      "Hello World"
    end
  end
end
