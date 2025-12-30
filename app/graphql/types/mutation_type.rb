# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    field :login, mutation: Mutations::Login
    field :signup, mutation: Mutations::Signup
    field :logout, mutation: Mutations::Logout
    def test_field
      "Hello World"
    end
  end
end
