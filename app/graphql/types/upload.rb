class Types::Upload < GraphQL::Schema::Scalar
  description "A file uploaded via multipart request"

  def self.coerce_input(value, _context)
    value
  end
end
