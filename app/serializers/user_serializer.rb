class UserSerializer
  include JSONAPI::Serializer
  attributes  :email, :created_at, :username, :phone, :gender, :date_of_birth, :country

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime('%m/%d/%Y')
  end
end
