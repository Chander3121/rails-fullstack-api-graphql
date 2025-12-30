module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :username, String, null: false
    field :firstname, String, null: false
    field :lastname, String, null: false
    field :bio, String, null: true
    field :github_username, String, null: true
    field :linkedin_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
