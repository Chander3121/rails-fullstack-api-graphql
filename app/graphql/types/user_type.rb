module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :username, String, null: false
    field :firstname, String, null: false
    field :lastname, String, null: false
    field :role, String, null: false
    field :bio, String, null: true
    field :github_username, String, null: true
    field :linkedin_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    # 🔹 Resume
    field :resume_url, String, null: true
    field :resume_filename, String, null: true
    def resume_url
      return nil unless object.resume.attached?

      Rails.application.routes.url_helpers.rails_blob_url(
        object.resume,
        only_path: true
      )
    end
    def resume_filename
      return nil unless object.resume.attached?

      object.resume.filename.to_s
    end
  end
end
