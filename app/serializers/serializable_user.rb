class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :birthdate,
             :created_at,
             :deleted_at,
             :email,
             :first_name,
             :last_name,
             :role,
             :updated_at,
             :username

  attribute :full_name do
    @object.full_name
  end

  # TO DO
  # attribute :profile_image do
  # end

  belongs_to :account
  belongs_to :last_updated_by, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true
end