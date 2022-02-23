class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :username,
             :first_name,
             :last_name,
             :email,
             :birthdate,
             :role,
             :profile_image

  attribute :full_name do
    @object.full_name
  end

  belongs_to :last_updated_by, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true
end