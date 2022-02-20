class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :username,
             :first_name,
             :last_name,
             :email,
             :birthdate,
             :role,
             :profile_image,
             :deleted_at

  attribute :full_name do
    @object.full_name
  end

  belongs_to :deleted_by, class_name: 'User', optional: true
end