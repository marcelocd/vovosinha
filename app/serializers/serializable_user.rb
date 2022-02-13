class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :first_name,
             :last_name,
             :email,
             :birthdate,
             :role,
             :profile_image

  attribute :full_name do
    @object.full_name
  end
end